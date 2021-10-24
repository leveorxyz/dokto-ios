# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

target 'Dokto' do
  
  pod 'RaveSDK'
  pod 'Paystack'
  pod 'PaystackCheckout'
  pod 'Stripe'
  pod 'PayPalCheckout'
  pod 'GoogleMaps'
  pod 'TwilioVideo'
  
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
    end
end
