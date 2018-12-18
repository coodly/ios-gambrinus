platform :ios, '9.3'

use_frameworks!

module PodSource
    Local = 1
    Remote = 2
    Tagged = 3
end

UsedSource = PodSource::Remote

def pods
    pod 'Fabric', '1.9.0'
    pod 'Crashlytics', '3.12.0'
    pod 'AFNetworking', '2.6.3'
    pod 'MRProgress', '0.8.3'
    pod 'Ono', '1.2.2'
    
    if UsedSource == PodSource::Local
        pod 'SWLogger', :path => '../swift-logger'
        pod 'LaughingAdventure', :path => '../swift-laughing-adventure'
    else
        pod 'SWLogger', :git => 'git@github.com:coodly/swlogger.git'
        pod 'LaughingAdventure', :git => 'git@github.com:coodly/laughing-adventure.git'
    end
end

def core_data_pod
    if UsedSource == PodSource::Local
        pod 'CoreDataPersistence', :path => '../swift-core-data-persistence'
        elsif UsedSource == PodSource::Remote
        pod 'CoreDataPersistence', :git => 'git@github.com:coodly/CoreDataPersistence.git'
        else
        pod 'CoreDataPersistence', :git => 'git@github.com:coodly/CoreDataPersistence.git', :tag => '0.1.6'
    end
end

target 'Gambrinus' do
    pods
    
end

target 'Kiosk' do
    platform :ios, '9.3'
    
end

target 'KioskUI' do
    platform :ios, '9.3'

    pod 'SwiftGen', '6.0.2'
end

target 'KioskCore' do
    platform :ios, '9.3'

    core_data_pod
end
