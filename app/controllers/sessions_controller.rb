class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def create
    employee = Employee.find_by(login_id: session_params[:login_id])

    if employee&.authenticate(session_params[:password])
      session[:user_id] = employee.id
      redirect_to root_url, notice: 'ログインしました。'
    else
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to login_url, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:login_id, :password)
  end
end
