class NotificationSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user
  def show
  end
end
