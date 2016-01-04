Pod::Spec.new do |s|
  s.name             = "<PACKAGENAME>"
  s.summary          = "A short description of <PACKAGENAME>."
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/<USERNAME>/<PACKAGENAME>"
  s.license          = 'MIT'
  s.author           = { "<AUTHOR_NAME>" => "<AUTHOR_EMAIL>" }
  s.source           = {
    :git => "https://github.com/<USERNAME>/<PACKAGENAME>.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/<USERNAME>'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.requires_arc = true
  s.requires_arc = true
  s.ios.source_files = 'Sources/{iOS,Shared}/**/*'
  s.osx.source_files = 'Sources/{Mac,Shared}/**/*'

  # s.ios.frameworks = 'UIKit', 'Foundation'
  # s.osx.frameworks = 'Cocoa', 'Foundation'
  
  # s.dependency 'Whisper', '~> 1.0'
end
