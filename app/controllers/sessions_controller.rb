class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        login_and_check_remember user
      else
        flash_not_active
      end
    else
      flash_create_error
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def login_and_check_remember user
    log_in user
    params[:session][:remember_me] == Settings.user.remember_me.check ? remember(user) : forget(user)
    redirect_back_or user
  end

  def flash_create_error
    flash[:danger] = t "session.flash.error"
    render :new
  end

  def flash_not_active
    message = t "user.flash.message_active_account"
    flash[:warning] = message
    redirect_to root_url
  end
end
