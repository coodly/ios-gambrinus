platform :ios, '9.3'

use_frameworks!

module PodSource
    Local = 1
    Remote = 2
    Tagged = 3
end

UsedSource = PodSource::Remote

def pods
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'AFNetworking', '2.6.3'
    pod 'MRProgress'
    pod 'Ono'
    
    if UsedSource == PodSource::Local
        pod 'SWLogger', :path => '../swift-logger'
        pod 'LaughingAdventure', :path => '../swift-laughing-adventure'
    else
        pod 'SWLogger', :git => 'git@github.com:coodly/swlogger.git'
        pod 'LaughingAdventure', :git => 'git@github.com:coodly/laughing-adventure.git'
    end
end

target 'Gambrinus' do
    pods
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            configuration.build_settings['SWIFT_VERSION'] = "3.0"
        end
    end
end
