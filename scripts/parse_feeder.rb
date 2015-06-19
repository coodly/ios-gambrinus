#
# Copyright 2015 Coodly LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'open-uri'
require 'json'
require 'unirest'
require 'date'
require 'cgi'
require 'yaml'

GAMBRINUS_BLOG_ID = '6051394756388860456'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class AppConfig
  def initialize(name)
    @file_name = ".#{name}.yml"
    @config = File::exist?(@file_name) ? YAML.load_file(@file_name) : {}
    @config ||= {}
  end

  def date_for(key, default = DateTime.new(2000, 1, 1))
    return default if @config.length == 0

    date_string = @config[key]
    return default if date_string.nil?

    DateTime.parse(date_string)
  end

  def set_date(date, key)
    @config[key] = date.xmlschema
    write
  end

  def write
    File.open(@file_name,'w') do |h|
      h.write @config.to_yaml
    end
  end
end

class BeersServer
  def initialize(token, parse_app)
    @token = token
    @config = AppConfig.new('beersapp')
    @parse = parse_app
  end

  def retrieve_updates
    last_check = @config.date_for('last_update')
    puts "Last beers update on #{last_check}"

    offset = 0
    limit = 100
    begin
      url = "https://www.beersapp.com/api/v1/beers?sort=updated_at&since=#{CGI.escape(last_check.xmlschema)}&offset=#{offset}&limit=#{limit}"
      puts url
      response = Unirest.get url, headers:{'X-Application-Token' => @token, 'Content-Type' => 'application/json'}
      json = response.body

      puts "#{json.length} updates"

      ids =  json.map { |d| d['id']}
      existing_data = @parse.check_existing_beers(ids)['results']
      existing_ids = existing_data.map { |e| e['identifier']}

      puts "Existing beers #{existing_ids}"

      json.each do |d|
        if d['rate_beer'].nil?
          puts "No RB info"
          next
        end

        if existing_ids.include?(d['id'])
          puts "Update #{d['name']}"
          object_id = object_id_for_identifier(d['id'], existing_data)
          if object_id.length == 0
            puts 'No data?'
            next
          end
          @parse.update_beer(object_id, d)
        else
          puts "Create #{d['name']}"
          @parse.save_beer(d)
        end
      end

      offset = offset + limit

      break if json.length != limit
    end while true

    @config.set_date(DateTime.now, 'last_update')
  end

  def object_id_for_identifier(beer_id, existing_data)
    existing_data.each do |d|
      return d['objectId'] if d['identifier'].equal?(beer_id)
    end

    ''
  end
end

class Blogger
  attr_accessor :page_token

  def initialize(blogger)
    @blogger = blogger
    @page_token = ''
  end

  def retrieve_next_page
    token_field = @page_token.length > 0 ? "pageToken=#{@page_token}" : ''
    url = "https://www.googleapis.com/blogger/v3/blogs/#{GAMBRINUS_BLOG_ID}/posts?#{token_field}&fields=nextPageToken,items(id,published,url,title)&maxResults=50&key=#{@blogger}"
    puts url
    result = open(url, 'Accept' => 'application/json')

    json = JSON.parse(result.string)
    @page_token = json['nextPageToken']

    json['items']
  end

  def has_more_pages?
    !@page_token.nil? && @page_token.length > 0
  end
end

class Parse
  def initialize(app_id, rest_key)
    @app_id = app_id
    @rest_key = rest_key
  end

  def save_post(post)
    data = {}
    data['identifier'] = post['id']
    date = DateTime.parse(post['published']).to_time.utc
    data['postDate'] = {:__type => 'Date',  :iso => date.xmlschema(3)}
    data['url'] = post['url']
    data['title'] = post['title']
    response = Unirest.post 'https://api.parse.com/1/classes/Post', headers:{'X-Parse-Application-Id' => @app_id, 'X-Parse-REST-API-Key' => @rest_key, 'Content-Type' => 'application/json'}, parameters:JSON.generate(data)
    puts "Posted '#{data['title']}'"
    exit(1) unless response.code == 201
  end

  def save_beer(beer)
    execute_beer_method(:post, beer)
  end

  def update_beer(object_id, beer)
    execute_beer_method(:put, beer, object_id)
  end

  def execute_beer_method(method, beer, object_id = '')
    data = {}
    data['identifier'] = beer['id']
    data['name'] = beer['name']
    data['alcohol'] = beer['alcohol']
    data['rbscore'] = beer['rate_beer']['score']
    data['rbidentifier'] = beer['rate_beer']['identifier']
    data['brewer'] = beer['rate_beer']['brewer']['name']
    data['style'] = beer['rate_beer']['style']['name']
    url = 'https://api.parse.com/1/classes/Beer'
    if object_id.length > 0
      url = "#{url}/#{object_id}"
    end

    puts "#{method} to #{url}"

    if method.equal?(:post)
      response = Unirest.post url, headers:{'X-Parse-Application-Id' => @app_id, 'X-Parse-REST-API-Key' => @rest_key, 'Content-Type' => 'application/json'}, parameters:JSON.generate(data)
      exit(1) unless response.code == 201
    elsif method.equal?(:put)
      response = Unirest.put url, headers:{'X-Parse-Application-Id' => @app_id, 'X-Parse-REST-API-Key' => @rest_key, 'Content-Type' => 'application/json'}, parameters:JSON.generate(data)
      exit(1) unless response.code == 200
    end
  end

  def check_existing_beers(ids)
    params = "where={\"identifier\":{\"$in\":[#{ids.join(',')}]}}"
    escaped = CGI.escape(params)
    check_url = "https://api.parse.com/1/classes/Beer?keys=identifier&#{escaped}"
    response = Unirest.get check_url, headers:{'X-Parse-Application-Id' => @app_id, 'X-Parse-REST-API-Key' => @rest_key, 'Content-Type' => 'application/json'}
    response.body
  end

  def check_existing_posts(ids)
    ids.collect! { |i|
      "\"#{i}\""
    }
    params = "where={\"identifier\":{\"$in\":[#{ids.join(',')}]}}"
    escaped = CGI.escape(params)
    response = Unirest.get "https://api.parse.com/1/classes/Post?keys=identifier&#{escaped}", headers:{'X-Parse-Application-Id' => @app_id, 'X-Parse-REST-API-Key' => @rest_key, 'Content-Type' => 'application/json'}
    response.body
  end
end

class ParseFeeder
  def initialize(blogger_key, parse_app_id, parse_rest_key, beers_app_token)
    @blogger = Blogger.new(blogger_key)
    @parse = Parse.new(parse_app_id, parse_rest_key)
    @beers = BeersServer.new(beers_app_token, @parse)
  end

  def execute
    puts 'Execute feeder'

    @beers.retrieve_updates
    return

    begin
      sleep(1)

      data = @blogger.retrieve_next_page

      ids =  data.map { |d| d['id']}
      existing = @parse.check_existing_posts(ids)['results'].map { |e| e['identifier']}
      puts existing.inspect

      data.each do |post|
        if existing.include?(post['id'])
          puts "Skip posting of #{post['title']}"
          next
        end

        @parse.save_post(post)
      end
    end while @blogger.has_more_pages?
  end
end


if ARGV.length != 4
  puts "Usage: parse_feeder.rb <blogger_api_key> <parse_app_id> <parse_rest_key> <beers_app_token>"
  exit(0)
end

blogger_key = ARGV[0]
parse_app_id = ARGV[1]
parse_rest_key = ARGV[2]
beers_app_token = ARGV[3]

feeder = ParseFeeder.new(blogger_key, parse_app_id, parse_rest_key, beers_app_token)
feeder.execute