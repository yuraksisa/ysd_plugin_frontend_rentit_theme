module YsdPluginFrontendRentitTheme
  module SinatraAdmin

    def self.registered(app)

      #
      # Setup the theme
      #
      app.get '/admin/booking/config/front-end-theme/rentit', :allowed_usergroups => ['booking_manager', 'staff'] do

        @slider_1_img = SystemConfiguration::Variable.get_value('frontend.skin.rentit.slider1_img_bg',nil)
        @color_scheme =  SystemConfiguration::Variable.get_value('frontend.skin.rentit.theme_color_scheme','')
        @header_background_color =  SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.header_background','#fbfbfb')
        @menu_top_hover_color =  SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.menu_top_hover_color', '#e60000')
        @menu_item_color =  SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.menu_item_color','#a5abb7')
        @menu_item_hover_color =  SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.menu_item_hover_color','#14181c')
        @submenu_background_color =  SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.submenu_background','#ffffff')
        @fixed_logo_sticky =  SystemConfiguration::Variable.get_value('frontend.skin.rentit.css.fixed_logo_sticky','false').to_bool

      end

    end
  end
end
