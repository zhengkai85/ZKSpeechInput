Pod::Spec.new do |s|
  s.name         = "ZKSpeechInput"
  s.version      = "1.0.0"
  s.summary      = "对ios原生的语音转成文字进行一次封装"
  s.homepage     = "https://github.com/zhengkai85/ZKSpeechInput"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "zhengkai" => "83794521@qq.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/zhengkai85/ZKSpeechInput.git", :tag => "1.0.0" }
  s.source_files = "ZKSpeechInput/*"  
  s.requires_arc = true
end
