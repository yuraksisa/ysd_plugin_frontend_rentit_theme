require 'adapters/ysd_menu_adapter' unless defined?Adapters::MenuAdapter
require 'renders/ysd_tree_render' unless defined?TreeRender

#
# Frontend rentit Extension
#
module YsdPluginFrontendRentitTheme

  class FrontendRentintThemeExtension < Plugins::ViewListener


    # ========= Installation =================

    #
    # Install the plugin
    #
    def install(context={})

      SystemConfiguration::Variable.first_or_create({:name => 'frontend.skin.rentit.slider1_img_bg'},
                                                    {:value => '.',
                                                     :description => 'Slider1 background image path',
                                                     :module => :frontend_rentit_theme})


      SystemConfiguration::Variable.first_or_create({:name => 'frontend.skin.rentit.css.header_background'},
                                                    {:value => '#fbfbfb',
                                                     :description => 'Slider1 background image path',
                                                     :module => :frontend_rentit_theme})

    end

    # ========== Build public layout =========

    #
    # Return the front end skin
    #
    def frontend_skin
      ['rentit']
    end

    #
    # Page layout : Get the page layout
    #
    def page_layout(context={}, layout_name)

      # Apply the layout
      if layout_name == 'page_render' and SystemConfiguration::Variable.get_value('frontend.skin', nil) == 'rentit'

        # Builds the primary link menu
        primary_links_menu = Site::Menu.first(name: 'primary_links')
        primary_links_menu_render = self.build_primary_links_menu(primary_links_menu,
                                                                  context[:app].request.path_info,
                                                                  context[:app].session[:locale],
                                                                  context[:app].settings.default_locale,
                                                                  context[:app].settings.multilanguage_site)
        # Builds the secondary links menu
        secondary_links_menu = Site::Menu.first(name: 'secondary_links')
        secondary_links_menu_render = self.build_secondary_links_menu(secondary_links_menu,
                                                                      context[:app].request.path_info,
                                                                      context[:app].session[:locale],
                                                                      context[:app].settings.default_locale,
                                                                      context[:app].settings.multilanguage_site)

        embedded = context[:app].request.params['embedded'] ? context[:app].request.params['embedded'].to_bool : false

        theme_attributes = {'css_header_background' => SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.header_background','#fbfbfb'),
                            'site_company_name' => SystemConfiguration::Variable.get_value('site.company.name', '.'),
                            'site_company_document_id' => SystemConfiguration::Variable.get_value('site.company.document_id', '.'),
                            'site_company_phone_number' => SystemConfiguration::Variable.get_value('site.company.phone_number', '.'),
                            'site_company_email' => SystemConfiguration::Variable.get_value('site.company.email', '.'),
                            'site_company_address_1' => SystemConfiguration::Variable.get_value('site.company.address_1', '.'),
                            'site_company_address_2' => SystemConfiguration::Variable.get_value('site.company.address_2', '.'),
                            'site_company_city' => SystemConfiguration::Variable.get_value('site.company.city', '.'),
                            'site_company_state' => SystemConfiguration::Variable.get_value('site.company.state', '.'),
                            'site_company_country' => SystemConfiguration::Variable.get_value('site.company.country', '.'),
                            'site_company_zip' => SystemConfiguration::Variable.get_value('site.company.zip', '.'),
                            'site_company_facebook' => SystemConfiguration::Variable.get_value('site.company.facebook', '.'),
                            'site_company_twitter' => SystemConfiguration::Variable.get_value('site.company.twitter', '.'),
                            'site_company_linkedin' => SystemConfiguration::Variable.get_value('site.company.linkedin', '.'),
                            'site_company_instagram' => SystemConfiguration::Variable.get_value('site.company.instagram', '.'),
                            'year' => Date.today.year,
                            'primary_links_menu' => primary_links_menu_render,
                            'secondary_links_menu' => secondary_links_menu_render,
                            'embedded' => embedded
        }

        # template
        template_file = File.open (File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'views','rentit_page_render.erb')))
        template = template_file.read
        page_template = Tilt.new('liquid') { template }
        page_render = page_template.render(context, theme_attributes )
        [page_render]
      else
        ['']
      end

    end

    protected

    #
    # Build a menu for a locale
    #
    def build_primary_links_menu(menu, request_path, locale, default_locale, multilanguage_site)

      start_menu    = "<ul class=\"nav sf-menu\">"
      start_submenu = "<li class=\"\"><a href=\"<%=branch[:link_route]%>\" title=\"branch[:description]\" class=\"sf-with-ul\"><%=branch[:title]%></a><ul>"
      menu_item     = "<li id=\"menu_item_<%=leaf[:id]%>\"><a href=\"<%=leaf[:link_route]%>\"><%=leaf[:title]%></a></li>"
      selected_menu_item = "<li id=\"menu_item_<%=leaf[:id]%>\" class=\"active\"><a href=\"<%=leaf[:link_route]%>\"><%=leaf[:title]%></a></li>"
      end_submenu   = "</ul></li>"
      end_menu      = "</ul>"
      separator     = "&nbsp;"
      extra_end_menu = "<% if (page.variables.has_key?(:languages_translation) and not page.variables[:languages_translation].empty?) %><div class=\"translation_language\"> <%= page.variables[:languages_translation]%></div><% end %>"

      menu_adapter = Adapters::MenuAdapter.new(menu, locale, default_locale, multilanguage_site)

      renderer = TreeRender.new(start_menu, start_submenu, menu_item, end_submenu, end_menu, separator,
                                extra_end_menu, selected_menu_item, request_path)
      renderer.render(menu_adapter.adapted_menu)

    end

    def build_secondary_links_menu(menu, request_path, locale, default_locale, multilanguage_site)

      start_menu    = "<ul>"
      start_submenu = "<li><a href=\"<%=branch[:link_route]%>\" title=\"branch[:description]\"><%=branch[:title]%></a><ul>"
      menu_item     = "<li id=\"menu_item_<%=leaf[:id]%>\"><a href=\"<%=leaf[:link_route]%>\"><%=leaf[:title]%></a></li>"
      selected_menu_item = nil
      end_submenu   = "</ul></li>"
      end_menu      = "</ul>"
      separator     = ""
      extra_end_menu = nil

      menu_adapter = Adapters::MenuAdapter.new(menu, locale, default_locale, multilanguage_site)

      renderer = TreeRender.new(start_menu, start_submenu, menu_item, end_submenu, end_menu, separator,
                                extra_end_menu, selected_menu_item, request_path)
      renderer.render(menu_adapter.adapted_menu)


    end

  end
end          