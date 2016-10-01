# Uncomment this line to define a global platform for your project
platform :ios, '9.3'
# Uncomment this line if you're using Swift

use_frameworks!

target 'Koalie' do
    pod 'Alamofire', '~> 4.0'
    pod 'AWSS3', '2.4.7'
    pod 'FBSDKCoreKit', '4.15.0'
    pod 'FBSDKLoginKit', '4.15.0'
    pod 'FBSDKShareKit', '4.15.0'
    pod 'LLSimpleCamera', '4.2'
    pod 'AwesomeCache', :git => 'https://github.com/aschuch/AwesomeCache.git', :branch => 'swift3.0'
    pod 'VIMVideoPlayer'
    pod 'GuillotineMenu', '~> 3.0'


end


target 'KoalieTests' do

end

def ensure_in_repo!
  return if Pathname.pwd.realpath.to_s.downcase == repo.realpath.to_s.downcase
  raise StandardError, "Must be in the root of the repo (#{repo}), " \
    "instead in #{Pathname.pwd}."
end

def allow_non_modular_includes(installer)
  installer.pods_project.build_configuration_list.build_configurations.each do |configuration|
    configuration.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
