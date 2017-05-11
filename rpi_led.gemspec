Gem::Specification.new do |s|
  s.name = 'rpi_led'
  s.version = '0.1.4'
  s.summary = 'Control the brightness of an LED (connected via GPIO) on a Raspberry Pi.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/rpi_led.rb']
  s.add_runtime_dependency('rpi_pwm', '~> 0.2', '>=0.2.0') 
  s.signing_key = '../privatekeys/rpi_led.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/rpi_led'
end
