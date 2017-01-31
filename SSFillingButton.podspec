#
# Be sure to run `pod lib lint SSFillingButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SSFillingButton'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SSFillingButton.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/sambhav7890/SSFillingButton'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sambhav7890' => 'sambhav.shah@practo.com' }
  s.source           = { :git => 'https://github.com/sambhav7890/SSFillingButton.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SSFillingButton/Classes/**/*.swift'
  
  s.frameworks = 'UIKit'

end
