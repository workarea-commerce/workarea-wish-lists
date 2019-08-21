$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'workarea/wish_lists/version'

Gem::Specification.new do |s|
  s.name        = 'workarea-wish_lists'
  s.version     = Workarea::WishLists::VERSION
  s.authors     = ['bcrouse']
  s.email       = ['bcrouse@weblinc.com']
  s.homepage    = 'https://github.com/workarea-commerce/workarea-wish-lists'
  s.summary     = 'Wish Lists plugin for the Workarea ecommerce platform'
  s.description = "Adds a wish list to user's account in the Workarea ecommerce platform"

  s.files = `git ls-files`.split("\n")

  s.license = 'Business Software License'

  s.required_ruby_version = '>= 2.3.0'

  s.add_dependency 'workarea', '~> 3.x', '>= 3.3.x'
end
