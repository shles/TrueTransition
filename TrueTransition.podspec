
Pod::Spec.new do |s|
  s.name             = 'TrueTransition'
  s.version          = '0.3.0'
  s.summary          = 'Simple pod for decoupling transitions.'
 
  s.description      = <<-DESC
	This library allows you to easily use different transitions
                       DESC
 
  s.homepage         = 'https://github.com/shles/transitionKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Artemiy Shlesberg' => 'temitrix@gmail.com' }
  s.source           = { :git => 'https://github.com/shles/transitionKit.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '11.0'
  s.source_files = '*'
  s.swift_version = '4.2'
end
