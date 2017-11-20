class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == Settings.user.remember_me.check ? remember(user) : forget(user)
      redirect_to user
    else
      flash_create_error
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def flash_create_error
    flash[:danger] = I18n.t "session.flash.error"
    render :new
  end
end
