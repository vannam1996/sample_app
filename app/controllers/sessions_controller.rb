class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      log_in user
      check_remember user
    else
      flash_create_error
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def check_remember user
    params[:session][:remember_me] == Settings.user.remember_me.check ? remember(user) : forget(user)
    redirect_back_or user
  end

  def flash_create_error
    flash[:danger] = I18n.t "session.flash.error"
    render :new
  end
end
