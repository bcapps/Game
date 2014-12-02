Pod::Spec.new do |s|
  s.name         = "LCKCategories"
  s.version      = "0.4"
  s.summary      = "LCKCategories is a repository for apps want to use common categories that extend functionality."
  s.homepage     = "http://lickability.com"
  s.author       = { "Lickability" => "http://lickability.com" }
  s.source       = { :git => "https://github.com/Lickability/LCKCategories.git", :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
    
  s.license      = "Copyright 2014 Lickability"
  s.requires_arc = true

  s.subspec 'CoreData' do |cd|
    cd.source_files = 'Classes/CoreData/*'
    cd.frameworks = 'CoreData'
  end
  
  s.subspec 'UIKit' do |ui|
    ui.source_files = 'Classes/UIKit/*'
    ui.frameworks = 'UIKit'
  end
  
  s.subspec 'Foundation' do |fd|
    fd.source_files = 'Classes/Foundation/*'
    fd.frameworks = 'Foundation'
  end
  
  s.subspec 'Utility' do |util|
    util.source_files = 'Classes/Utility/*'
    util.frameworks = 'Foundation', 'UIKit'
  end

end
