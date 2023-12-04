class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :set_current_user

  def set_current_user
    @current_user = current_user
  end
end
