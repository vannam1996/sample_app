class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def new; end

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "micropost.flash.save_post"
      redirect_to root_url
    else
      @feed_items = Micropost.feed_user(current_user.id).order_by_date.paginate page: params[:page]
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.flash.delete_post"
    else
      flash[:danger] = t "micropost.flash.delete_post_error"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url if @micropost.nil?
  end
end
