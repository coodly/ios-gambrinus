platform :ios, '9.3'

use_frameworks!

UseLocalPods = false

def pods
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'AFNetworking', '2.6.3'
    pod 'Parse', '1.14.2'
    pod 'MRProgress'
    pod 'Ono'
    
    if UseLocalPods

    else

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
