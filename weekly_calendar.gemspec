# -*- encoding: utf-8 -*-
require File.expand_path('../lib/weekly_calendar/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Colin Young"]
  gem.email         = ["me@colinyoung.com"]
  gem.description   = %q{weekly calendar that supports tasks and multi-day events}
  gem.summary       = %q{weekly calendar that supports tasks and multi-day events}
  gem.homepage      = ""
  
  gem.add_dependency 'week'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "weekly_calendar"
  gem.require_paths = ["lib"]
  gem.version       = WeeklyCalendar::VERSION
end
