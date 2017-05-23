$LOAD_PATH.unshift 'lib'
require "agile_serializer/version"

Gem::Specification.new do |s|
  s.name              = "agile_serializer"
  s.version           = AgileSerializer::VERSION
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Enhanced serialize options for rails, forked from serialize_with_options"
  s.homepage          = "http://github.com/ctrochalakis/agile_serializer"
  s.email             = "yatiohi@ideopolis.gr"
  s.authors           = [ "Christos Trochalakis" ]
  s.has_rdoc          = false

  s.files             = %w( README.markdown Rakefile MIT-LICENSE )
  s.files            += Dir.glob("lib/**/*.rb")
  s.files            += Dir.glob("test/**/*.rb")

  s.description       = "A fork of serializer_with_options enabling deep serializer and other features"

  s.add_dependency("railties", ">= 4.2", "< 6")

  s.add_development_dependency 'activerecord', ">= 4.2", "< 6"
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'json'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-color'
  s.add_development_dependency 'minitest-focus'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'appraisal'
end
