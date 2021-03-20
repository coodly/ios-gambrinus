source 'https://github.com/coodly/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.3'

use_frameworks!

module PodSource
    Local = 1
    Remote = 2
    Tagged = 3
end

UsedSource = PodSource::Remote

def core_data_pod
    if UsedSource == PodSource::Local
        pod 'CoreDataPersistence', :path => '../swift-core-data-persistence'
        elsif UsedSource == PodSource::Remote
        pod 'CoreDataPersistence', :git => 'git@github.com:coodly/CoreDataPersistence.git'
        else
        pod 'CoreDataPersistence', :git => 'git@github.com:coodly/CoreDataPersistence.git', :tag => '0.1.9'
    end
end

def log_pod
    if UsedSource == PodSource::Local
        pod 'SWLogger', :path => '../swift-logger'
    elsif UsedSource == PodSource::Remote
        pod 'SWLogger', :git => 'git@github.com:coodly/swlogger.git'
    else
        pod 'SWLogger', :git => 'git@github.com:coodly/swlogger.git', tag: '0.3.6'
    end
end

def images_pod
    if UsedSource == PodSource::Local
        pod 'ImageProvide', :path => '../swift-image-provide'
    elsif UsedSource == PodSource::Remote
        pod 'ImageProvide', :git => 'git@github.com:coodly/ImageProvide.git'
    else
        pod 'ImageProvide', :git => 'git@github.com:coodly/ImageProvide.git', tag: '0.4.1'
    end
end

def blogger_pod
    if UsedSource == PodSource::Local
        pod 'BloggerAPI', :path => '../swift-blogger-api'
    elsif UsedSource == PodSource::Remote
        pod 'BloggerAPI', :git => 'git@github.com:coodly/BloggerAPI.git'
    else
        pod 'BloggerAPI', :git => 'git@github.com:coodly/BloggerAPI.git', tag: '0.1.0'
    end
end

def puff_pod
    if UsedSource == PodSource::Local
        pod 'Puff/Core', :path => '../swift-puff'
    elsif UsedSource == PodSource::Remote
        pod 'Puff/Core', :git => 'git@github.com:coodly/Puff.git'
    else
        pod 'Puff/Core', :git => 'git@github.com:coodly/Puff.git', tag: '0.5.1'
    end
end


target 'Kiosk' do
    platform :ios, '9.3'
end

target 'KioskUI' do
    platform :ios, '9.3'

    pod 'SwiftGen', '6.0.2'
    images_pod
    blogger_pod
end

target 'KioskCore' do
    platform :ios, '9.3'

    core_data_pod
    log_pod
    images_pod
    blogger_pod
    puff_pod
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.3'
      end
    end
end
