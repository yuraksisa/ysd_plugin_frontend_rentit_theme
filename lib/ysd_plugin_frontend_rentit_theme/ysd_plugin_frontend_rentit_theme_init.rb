require 'ysd-plugins' unless defined?Plugins::Plugin

Plugins::SinatraAppPlugin.register :frontend_rentit_theme do

  name=        'frontend_rentit_theme'
  author=      'yurak sisa'
  description= 'tryton'
  version=     '0.1'
  sinatra_extension YsdPluginFrontendRentitTheme::Sinatra
  sinatra_extension YsdPluginFrontendRentitTheme::SinatraAdmin
  hooker YsdPluginFrontendRentitTheme::FrontendRentintThemeExtension

end