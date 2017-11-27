class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build if logged_in?
    following_ids = Relationship.followed_ids current_user.id
    @feed_items = Micropost.feed_for_home(current_user.id, following_ids).order_by_date.paginate page: params[:page]
  end

  def help; end

  def about; end

  def contact; end
end
