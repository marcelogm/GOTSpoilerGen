class AdminAreasController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:approved] == "false"
      @users = User.where(approved: false)
    else
      @users = User.all
    end
  end
end
