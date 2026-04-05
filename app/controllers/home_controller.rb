class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @breads = current_group.breads
  end
end
