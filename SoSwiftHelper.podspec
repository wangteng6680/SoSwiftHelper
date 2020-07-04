#
# Be sure to run `pod lib lint SoSwiftHelper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SoSwiftHelper'
  s.version          = '0.1.0'
  s.summary          = 'Swift 工具类'
  s.description      = <<-DESC
Swift 工具类 Foundation、UIKit、Helper
                       DESC
  s.homepage         = 'https://github.com/wangteng6680/SoSwiftHelper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangteng6680' => 'wangteng6680@163.com' }
  s.source           = { :git => 'https://github.com/wangteng6680/SoSwiftHelper.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.swift_version = '4.2'

  s.subspec 'Core' do |core|
      core.source_files = 'SoSwiftHelper/Classes/Core/**/*.swift'
  end
  
  s.subspec 'Helper' do |helper|
    helper.source_files = 'SoSwiftHelper/Classes/Helper/**/*.swift'
  end

  s.subspec 'Foundation' do |f|
      f.source_files = 'SoSwiftHelper/Classes/Foundation/**/*.swift'
      f.dependency 'SoSwiftHelper/Core'
  end

  s.subspec 'UIKit' do |uikit|
      uikit.source_files = 'SoSwiftHelper/Classes/UIKit/**/*.swift'
      uikit.dependency 'SoSwiftHelper/Core'
      uikit.dependency 'SoSwiftHelper/Foundation'
  end

end
