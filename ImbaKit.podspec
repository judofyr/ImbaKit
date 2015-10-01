#
# Be sure to run `pod lib lint ImbaKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ImbaKit"
  s.version          = "0.1.0"
  s.summary          = "Imba tags and tools for UIKit"

  s.homepage         = "https://github.com/judofyr/ImbaKit"
  s.license          = 'MIT'
  s.author           = { "Magnus Holm" => "judofyr@gmail.com" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true


  s.source_files = ['Pod/Classes/**/*', 'Pod/Deps/**/*']
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.private_header_files = 'Pod/Deps/**/*.h'

  s.frameworks = 'UIKit'
end
