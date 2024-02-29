#
# Be sure to run `pod lib lint LottieService.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LottieService'
  s.version          = '0.1.4'
  s.summary          = 'Lottie增强'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 使Lottie能够加载带图片的远程动效文件的压缩包
                       DESC

  s.homepage         = 'https://github.com/Sfh03031/LottieService'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sfh03031' => 'sfh894645252@foxmail.com' }
  s.source           = { :git => 'https://github.com/Sfh03031/LottieService.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'LottieService/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LottieService' => ['LottieService/Assets/*.png']
  # }

  # s.public_header_files = 'LottieService/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'lottie-ios', '2.5.3'
  s.dependency 'SSZipArchive'
  
end
