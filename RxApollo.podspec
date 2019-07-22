#
# Be sure to run `pod lib lint RxApollo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxApollo'
  s.version          = '1.0.0'
  s.summary          = 'RxSwift and PromiseKit wrappers for Apollo'
  s.description      = 'RxSwift and PromiseKit wrappers for Apollo'
  s.homepage         = 'https://github.com/patsluth/RxApollo'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'patsluth' => 'pat.sluth@gmail.com' }
  s.source           = { :git => 'https://github.com/patsluth/RxApollo.git', :tag => s.version.to_s }
  
  s.swift_version = '5.0'

  s.ios.deployment_target = '9.0'

  s.source_files = 'RxApollo/Classes/**/*'
  
  s.ios.dependency 'Apollo'
  s.ios.dependency 'RxSwift'
  s.ios.dependency 'RxCocoa'
  s.ios.dependency 'RxSwiftExt'
  s.ios.dependency 'PromiseKit'
  s.ios.dependency 'CancelForPromiseKit'
end
