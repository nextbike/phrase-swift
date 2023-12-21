# Be sure to run `pod lib lint phrase_swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PhraseSwift'
  s.version          = '1.0.1'
  s.summary          = 'A swift port of Squares Phrase library.'

  s.description      = <<-DESC
Use curly bracket placeholders within strings and be able to use the same localization phrases as on Android.
                       DESC

  s.homepage         = 'https://github.com/nextbike/phrase-swift'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'Jonas Vogel' => 'vogel@nextbike.com' }
  s.source           = { :git => 'https://github.com/nextbike/phrase-swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.swift_versions = ['5']

  s.source_files = 'Sources/PhraseSwift/*.swift', 'Sources/PhraseSwift/Extensions/*.swift'

  s.frameworks = 'Foundation'
end
