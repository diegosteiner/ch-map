Gem::Specification.new do |s|
  s.name = "ch_map"
  s.version = "0.2"
  s.authors = ["Diego Steiner"]
  s.email = "filou.linux@gmail.com"
  s.summary = "Interactive SVG map of the swiss cantonts"
  s.description = "Interactive SVG map of the swiss cantonts"
  s.homepage = ""

  s.add_runtime_dependency "railties", ">= 3.1.0"

  s.files = Dir["lib/**/*"] + ["README.md", "LICENSE"]
end
