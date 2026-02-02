class HomeController < ApplicationController
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    home_path
  end
end

end
