Pod::Spec.new do |s|
  s.name         = "LCKCoreData"
  s.version      = "2.1"
  s.summary      = "LCKCoreData is a repository for apps that want to use Core Data"
  s.homepage     = "http://lickability.com"
  s.author       = { "Lickability" => "http://lickability.com" }
  s.source       = { :git => "git@github.com:Lickability/LCKCoreData.git", :tag => s.version.to_s }

  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  
  s.license      = "Copyright 2014 Lickability"
  s.requires_arc = true
  
  s.subspec 'Core' do |core|
  	core.source_files = 'Classes/LCKCoreDataController.{h,m}'
	core.frameworks = 'CoreData'
  end
  
  s.subspec 'UIKit' do |uikit|
    uikit.source_files = 'Classes/LCKCoreDataTableViewController.{h,m}'
	uikit.frameworks = 'UIKit'
  end
  
end
