class PasswordResetsController < ApplicationController
  before_action :user_get, only: %i(update edit)
  before_action :valid_user, only: %i(update edit)
  before_action :check_expiration, only: %i(update edit)
  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "user_mailer.password_reset.send_mail"
      redirect_to root_url
    else
      flash[:danger] = t "user_mailer.password_reset.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("user_mailer.password_reset.error_empty")
      render :edit
    elsif @user.update_attributes user_params
      update_success
    else
      render :edit
    end
  end

  private

  def update_success
    log_in @user
    @user.update_attributes reset_digest: nil
    flash[:success] = t "user_mailer.password_reset.change_success"
    redirect_to @user
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def user_get
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "user_mailer.password_reset.expired"
    redirect_to new_password_reset_url
  end
end
