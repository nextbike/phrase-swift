# Be sure to run `pod lib lint phrase_swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PhraseSwift'
  s.version          = '0.1.2'
  s.summary          = 'A swift port of Squares Phrase library.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/nextbike/phrase-swift'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'Jan Meier' => 'meier@nextbike.com' }
  s.source           = { :git => 'https://github.com/nextbike/phrase-swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.swift_versions = ['4', '5']

  s.source_files = 'PhraseSwift/PhraseSwift/*.swift', 'PhraseSwift/PhraseSwift/Extensions/*.swift'

  s.frameworks = 'UIKit'
end
