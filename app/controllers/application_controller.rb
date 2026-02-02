class ApplicationController < ActionController::Base
  # app/controllers/application_controller.rb
def after_sign_in_path_for(resource)
  home_path
end

end
