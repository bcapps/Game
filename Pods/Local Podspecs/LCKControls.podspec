Pod::Spec.new do |s|
  s.name             = "LCKControls"
  s.version          = "1.1"
  s.summary          = "This pod is used to hold common controls that are used across applications."
  s.homepage         = "https://github.com/Lickability/LCKControls/"
  s.license          = 'Copyright 2014 Lickability'
  s.author           = { "Lickability" => "http://lickability.com" }
  s.source           = { :git => "https://github.com/Lickability/LCKControls.git", :tag => s.version.to_s }

  s.osx.deployment_target = '10.9'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets'
  s.dependency 'LCKCategories', '~> 0.0'
  s.dependency 'SVProgressHUD', '~> 1.0'
  s.frameworks = 'UIKit', 'Foundation'

end
