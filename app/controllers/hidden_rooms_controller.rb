class HiddenRoomsController < ApplicationController
  before_action :authenticate_user

  def create
    HiddenRoom.create(user_id: @current_user.id, room_id: params[:room_id])
    flash[:notice] = "非表示にしました"
    redirect_to "/rooms"
  end
end
