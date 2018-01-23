#
# Tryton Extension
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
        # theme attributes
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
                            'year' => Date.today.year
                           }
        
        # template
        template_file = File.open (File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'views','rentit_page_render.erb')))
        template = template_file.read
        page_template = Tilt.new('liquid') { template }
        page_render = page_template.render(context, theme_attributes )
        [page_render]
        #[template]
      else
        ['']
      end

    end

  end
end          