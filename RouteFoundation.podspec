#
#  Be sure to run `pod spec lint RouteFoundation.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "RouteFoundation"
  spec.version      = "0.0.1"
  spec.summary      = "An easy-to-use and lightweight Route in swift for UIKit."

  spec.description  = <<-DESC
An easy-to-use and lightweight Route in swift for UIKit
                   DESC

  spec.homepage     = "https://github.com/tjerwinchen/RouteFoundation"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Theo Chen" => "theo.chen@codebase.codes" }
  spec.social_media_url   = "https://twitter.com/zhecui"

  spec.ios.deployment_target = "13.0"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/tjerwinchen/RouteFoundation.git", :tag => "#{spec.version}" }
  spec.source_files = "Sources/RouteFoundation/**/*.{h,m,swift}"
  
end
