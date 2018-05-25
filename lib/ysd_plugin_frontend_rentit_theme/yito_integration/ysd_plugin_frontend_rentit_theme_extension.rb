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

      SystemConfiguration::Variable.first_or_create({:name => 'frontend.skin.rentit.theme_color_scheme'},
                                                    {:value => '',
                                                     :description => 'Slider1 background image path',
                                                     :module => :frontend_rentit_theme})

      SystemConfiguration::Variable.first_or_create({:name => 'frontend.skin.rentit.css.header_background'},
                                                    {:value => '#fbfbfb',
                                                     :description => 'Slider1 background image path',
                                                     :module => :frontend_rentit_theme})

      SystemConfiguration::Variable.first_or_create({:name => 'frontend.skin.rentit.css.menu_top_hover_color'},
                                                    {:value => '#e60000',
                                                     :description => 'Menu top hover color',
                                                     :module => :frontend_rentit_theme})

      SystemConfiguration::Variable.first_or_create({:name => 'frontend.skin.rentit.css.menu_item_color'},
                                                    {:value => '#a5abb7',
                                                     :description => 'Menu item hover color',
                                                     :module => :frontend_rentit_theme})

      SystemConfiguration::Variable.first_or_create({:name => 'frontend.skin.rentit.css.menu_item_hover_color'},
                                                    {:value => '#14181c',
                                                     :description => 'Menu item hover color',
                                                     :module => :frontend_rentit_theme})

      SystemConfiguration::Variable.first_or_create({:name => 'frontend.skin.rentit.css.submenu_background'},
                                                    {:value => '#ffffff',
                                                     :description => 'Submenu background color',
                                                     :module => :frontend_rentit_theme})

      SystemConfiguration::Variable.first_or_create({:name => 'frontend.skin.rentit.css.fixed_logo_sticky'},
                                                    {:value => 'false',
                                                     :description => 'Fixed logo on sticky',
                                                     :module => :frontend_rentit_theme})

    end

    # ========== Build public layout =========

    #
    # Return the front end skin
    #
    def frontend_skin(context={})
      ['rentit']
    end

    #
    # Configure if the theme uses custom js
    #
    def frontend_skin_custom_js(context={})
      false
    end


    #
    # Page layout : Get the page layout
    #
    def page_layout(context={}, layout_name)

      # Apply the layout
      if layout_name == 'page_render' and SystemConfiguration::Variable.get_value('frontend.skin', nil) == 'rentit'

        home_page = SystemConfiguration::Variable.get_value('site.anonymous_front_page')
        primary_secondary_links_menu = context[:app].primary_secondary_links_menu?

        # Builds the primary link menu
        primary_links_menu = if primary_secondary_links_menu
                               Site::Menu.first(name: 'primary_links')
                             else
                               Site::Menu.first(name: 'primary_links_activities')
                             end

        # Check if show shopping cart
        renting_plan, activities_plan = context[:app].mybooking_plan_type
        only_activities = (activities_plan and !renting_plan)
        full_own_menu = (activities_plan and renting_plan and SystemConfiguration::Variable.get_value('booking.frontend.activities_menu','false').to_bool)
        show_shopping_cart = ((only_activities or (full_own_menu and !primary_secondary_links_menu)) and !context[:app].activities_summaries_pages?)

        primary_links_menu_render = self.build_primary_links_menu(primary_links_menu,
                                                                  context[:app].request.path_info,
                                                                  context[:app].session[:locale],
                                                                  context[:app].settings.default_locale,
                                                                  context[:app].settings.multilanguage_site,
                                                                  show_shopping_cart)
        # Builds the secondary links menu
        secondary_links_menu = if primary_secondary_links_menu
                                 Site::Menu.first(name: 'secondary_links')
                               else
                                 Site::Menu.first(name: 'secondary_links_activities')
                               end

        secondary_links_menu_render = self.build_secondary_links_menu(secondary_links_menu,
                                                                      context[:app].request.path_info,
                                                                      context[:app].session[:locale],
                                                                      context[:app].settings.default_locale,
                                                                      context[:app].settings.multilanguage_site)

        embedded = context[:app].request.params['embedded'] ? context[:app].request.params['embedded'].to_bool : false

        theme_attributes = {'theme_color_scheme' => SystemConfiguration::Variable.get_value('frontend.skin.rentit.theme_color_scheme', ''),
                            'css_header_background' => SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.header_background','#fbfbfb'),
                            'css_menu_item_color' => SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.menu_item_color','#a5abb7'),
                            'css_menu_item_hover_color' => SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.menu_item_hover_color','#14181c'),
                            'css_menu_top_hover_color' => SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.menu_top_hover_color','#e60000'),
                            'css_submenu_background' => SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.submenu_background','#ffffff'),
                            'css_fixed_logo_sticky' => SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.fixed_logo_sticky', 'false').to_bool,
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
                            'embedded' => embedded,
                            'home' => (context[:app].request.path_info == home_page or context[:app].request.path_info == '/')
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
    def build_primary_links_menu(menu, request_path, locale, default_locale, multilanguage_site, shopping_cart)

      start_menu    = "<ul class=\"nav sf-menu\">"
      start_submenu = "<li class=\"\"><a href=\"<%=branch[:link_route]%>\" title=\"branch[:description]\" class=\"sf-with-ul\"><%=branch[:title]%></a><ul>"
      menu_item     = "<li id=\"menu_item_<%=leaf[:id]%>\"><a href=\"<%=leaf[:link_route]%>\"><%=leaf[:title]%></a></li>"
      selected_menu_item = "<li id=\"menu_item_<%=leaf[:id]%>\" class=\"active\"><a href=\"<%=leaf[:link_route]%>\"><%=leaf[:title]%></a></li>"
      end_submenu   = "</ul></li>"
      end_menu      = "</ul>"
      separator     = "&nbsp;"
      extra_end_menu = "<% if (page.variables.has_key?(:languages_translation) and not page.variables[:languages_translation].empty?) %><li><div class=\"translation_language\"> <%= page.variables[:languages_translation]%></div></li><% end %>"
      if shopping_cart
        extra_end_menu << "<% if (page.variables.has_key?(:shopping_cart) and not page.variables[:shopping_cart].empty?)%><li><div class=\"shopping_cart\"><%=page.variables[:shopping_cart]%></div></li><% end %>"
      end

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