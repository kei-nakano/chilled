class NoticesController < ApplicationController
  def index
    @notices = @current_user.passive_notices
    @latest_notices = @notices.where(checked: false).order(created_at: :desc).includes(:comment, :visitor, :review)
    @old_notices = @notices.where.not(id: @latest_notices.ids).order(created_at: :desc).includes(:comment, :visitor, :review)
    @latest_notices.each do |notice|
      notice.update(checked: true)
    end
  end

  def destroy
    @notices = @current_user.passive_notices.destroy_all
    redirect_to "/notices"
  end
end
