class RoomsController < ApplicationController
  def show
    @room = Room.find(params[:room_id])
    @user = User.find(params[:user_id])
    @messages = Message.includes(:user).where(room_id: @room.id)
  end
end
