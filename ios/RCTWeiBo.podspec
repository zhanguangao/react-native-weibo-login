#
#  Be sure to run `pod spec lint RCTWeiboAPI.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "RCTWeibo"
  s.version      = "0.0.1"
  s.summary      = "React-Native(iOS/Android) functionalities include Weibo Login"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                  React-Native(iOS/Android) functionalities include Weibo Login
                   DESC

  s.homepage     = "https://github.com/GoyouTech/react-native-weibo-login"
  s.license      = "MIT"
  
	s.author             = { "GoyouTech" => "developer@goyouapp.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/GoyouTech/react-native-weibo.git", :tag => "master" }
  s.source_files  = "**/*.{h,m}"
  s.requires_arc = true

  s.dependency "React"
  s.vendored_libraries = "libWeiboSDK.a"
  s.resource = "WeiboSDK.bundle"
  s.ios.frameworks = 'QuartzCore', 'ImageIO', 'SystemConfiguration', 'Security', 'CoreTelephony', 'CoreText', 'UIKit', 'Foundation', 'CoreGraphics', 'Photos'
  s.ios.library = 'sqlite3','z'

end
