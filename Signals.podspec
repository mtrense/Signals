Pod::Spec.new do |s|
  s.name = 'Signals'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Elegant eventing'
  s.homepage = 'https://github.com/artman/Signals'
  s.social_media_url = 'http://twitter.com/artman'
  s.authors = { 'Tuomas Artman' => 'tuomas@artman.fi' }
  s.source = { :git => 'https://github.com/artman/Signals.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Signals/*.swift'

  s.requires_arc = true
end
