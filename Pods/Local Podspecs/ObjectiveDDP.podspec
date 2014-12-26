Pod::Spec.new do |s|
  s.name           = 'ObjectiveDDP'
  s.ios.deployment_target = '7.1'
  s.osx.deployment_target = '10.7'
  s.version        = '0.1.9'
  s.license        = 'MIT'
  s.summary        = 'Facilitates communication between iOS clients and meteor.js servers'
  s.homepage       = 'https://github.com/boundsj/ObjectiveDDP.git'
  s.author         = 'Jesse Bounds'
  s.source         = { :git => 'https://github.com/boundsj/ObjectiveDDP.git', :tag => 'v0.1.9' }
  s.source_files   = 'ObjectiveDDP/*.{h,m,c}'
  s.requires_arc   = true
  s.dependency 'SocketRocket', '0.3.1-beta2'
  s.dependency 'M13OrderedDictionary'
end
