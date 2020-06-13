class RoomsController < ApplicationController
  def show
    @room = Room.find(params[:room_id])
    @user = User.find(params[:user_id])
    if @current_user.block_ids.include?(@user.id)
      flash[:notice] = "このユーザをブロックしているため、メッセージを送ることができません。"
      redirect_to @user
    end
    @messages = Message.includes(:user).where(room_id: @room.id)
  end

  def create
    @room_id = Room.create.id
    @user = User.find(params[:user_id])
    Entry.create(user_id: @current_user.id, room_id: @room_id)
    Entry.create(user_id: @user.id, room_id: @room_id)
    redirect_to "/users/#{@user.id}/room/#{@room_id}"
  end

  def index
    @users = @current_user.dm_members
  end
end
