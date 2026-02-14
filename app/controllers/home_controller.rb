class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @breads = current_user.breads
  end
end
