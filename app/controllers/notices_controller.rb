class NoticesController < ApplicationController
  def index
    @notices = @current_user.passive_notices.order(created_at: :desc).includes(:comment, :visitor, :review)
  end

  def destroy
    @notices = @current_user.passive_notices.destroy_all
    redirect_to "/notices"
  end
end
