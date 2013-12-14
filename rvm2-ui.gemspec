#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require File.expand_path("../lib/rvm2/ui/version.rb", __FILE__)

Gem::Specification.new do |s|
  s.name = "rvm2-ui"
  s.version = Rvm2::Ui::VERSION
  s.authors = ["Michal Papis"]
  s.email = ["mpapis@gmail.com"]
  s.homepage = "https://github.com/rvm/rvm2-ui"
  s.summary = "Abstract user interface handling in RVM2"
  s.license = "Apache 2.0"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.required_ruby_version = ">= 2.0.0"
  s.add_dependency('pluginator')
  %w{rake minitest simplecov coveralls redcarpet}.each do |name|
    s.add_development_dependency(name)
  end
  # s.add_development_dependency("smf-gem")
end
