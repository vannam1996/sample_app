class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build if logged_in?
    @feed_items = Micropost.feed_user(current_user.id).order_by_date.paginate page: params[:page]
  end

  def help; end

  def about; end

  def contact; end
end
