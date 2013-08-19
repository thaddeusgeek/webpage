Gem::Specification.new do |s|
s.name 			= %q{webpage}
s.version 		= '0.0.11'
s.authors 		= ["seoaqua"]
s.date 			= %q{2013-02-28}
s.description 	= %q{a tool to extract some basic data from a webpage}
s.email 		= %q{seoaqua@qq.com}
s.files			= `git ls-files`.split("\n")
s.homepage 		= %q{https://github.com/seoaqua/webpage}
s.summary = s.description
s.add_development_dependency 'nokogiri'
end
