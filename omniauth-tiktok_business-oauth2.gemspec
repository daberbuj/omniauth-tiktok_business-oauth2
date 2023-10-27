require_relative 'lib/omniauth-tiktok_business-oauth2/version'

Gem::Specification.new do |gem|
  gem.name          = 'omniauth-tiktok_business-oauth2'
  gem.version       = OmniAuthTiktokBusinessOauth2::VERSION
  gem.license       = 'MIT'
  gem.summary       = %(A TikTok Business API OAuth2 strategy for OmniAuth)
  gem.description   = %(A TikTok Business API OAuth2 strategy for OmniAuth. This allows you to login with TikTok in your ruby app.)
  gem.authors       = ['Damian Aberbuj']
  gem.homepage      = 'https://github.com/daberbuj/omniauth-tiktok_business-oauth2'

  gem.files         = `git ls-files`.split("\n")
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'omniauth-oauth2', '~> 1.6'
  gem.add_runtime_dependency 'oauth2', '~> 1.1'
end
