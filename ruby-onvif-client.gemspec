Gem::Specification.new do |s|
    s.name        = 'ruby_onvif_client'
    s.version     = '0.1.6'
    s.date        = '2013-08-22'
    s.summary     = "Ruby ONVIF"
    s.description = "Ruby ONVIF"
    s.authors     = ["jimxl"]
    s.email       = 'tianxiaxl@gmail.com'
    s.require_paths = ['lib']
    s.files = Dir.glob("lib/**/*") + %w{Gemfile ruby-onvif-client.gemspec}
    s.homepage    = 'http://dreamcoder.info'

    s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
    s.add_dependency 'em_ws_discovery'
    s.add_dependency 'em-http-request'
    s.add_dependency 'em-http-server'
    s.add_dependency 'activesupport' , '~> 3.2'
    s.add_dependency 'akami'
    s.add_dependency 'nokogiri', '~> 1.9'
end

