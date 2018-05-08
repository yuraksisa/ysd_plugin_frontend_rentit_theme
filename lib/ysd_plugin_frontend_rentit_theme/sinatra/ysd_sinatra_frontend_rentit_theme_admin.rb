module YsdPluginFrontendRentitTheme
  module SinatraAdmin

    def self.registered(app)

      app.get '/admin/booking/config/front-end-theme/rentit', :allowed_usergroups => ['booking_manager', 'staff'] do

      end

    end
  end
end
