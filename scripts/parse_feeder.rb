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

GAMBRINUS_BLOG_ID = '6051394756388860456'

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
     @page_token.length > 0
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
end

class ParseFeeder
  def initialize(blogger_key, parse_app_id, parse_rest_key)
    @blogger = Blogger.new(blogger_key)
    @parse = Parse.new(parse_app_id, parse_rest_key)
  end

  def execute
    puts 'Execute feeder'

    begin
      sleep(1)

      data = @blogger.retrieve_next_page

      data.each do |post|
        @parse.save_post(post)
      end
    end while @blogger.has_more_pages?
  end
end


if ARGV.length != 3
  puts "Usage: parse_feeder.rb <blogger_api_key> <parse_app_id> <parse_rest_key>"
  exit(0)
end

blogger_key = ARGV[0]
parse_app_id = ARGV[1]
parse_rest_key = ARGV[2]

feeder = ParseFeeder.new(blogger_key, parse_app_id, parse_rest_key)
feeder.execute