Pod::Spec.new do |s|
  s.name                  = "DUIMKit"
  s.version               = "0.0.1"
  s.summary               = "Style your apps using CSS"
  s.description           = "Style your apps using CSS."
  s.homepage              = "https://github.com/angelolloqui/DUIMKit"
  s.license               = "MIT License"
  s.author                = { "Angel Garcia Olloqui" => "http://angelolloqui.com" }
  s.source                = { :git => "https://github.com/angelolloqui/DUIMKit.git" }
  s.platform              = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source_files          = 'DUIMKit/**/*.{h,m}'
  s.resources             = "DUIMKit/DUI.js"
  s.frameworks            = 'JavaScriptCore'
  s.requires_arc          = true
end
