class MenuController < ApplicationController
  def index
    @current_user = current_user.employee_name
  end
end
