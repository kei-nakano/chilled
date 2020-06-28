class RoomsController < ApplicationController
  def show
    @room = Room.find(params[:id])
    @user = User.find(params[:user_id])
    if block_ids(@current_user).include?(@user.id)
      flash[:notice] = "このユーザをブロックしているかブロックされているため、メッセージを送ることができません。"
      redirect_back(fallback_location: "/users/#{@user.id}")
    end

    # roomに入った時点で、未読メッセージのステータスを全て既読に変更する
    @messages = Message.includes(:user).where(room_id: @room.id)
    unread_messages = @messages.where(checked: false, user_id: @user.id)
    unread_messages.each do |message|
      message.update_attribute(:checked, true)
    end
    MessageStatusChangeJob.perform_later @room.id, @user.id # クライアントの画面をJob経由で更新する
  end

  def create
    @room_id = Room.create.id
    @user = User.find(params[:user_id])
    Entry.create(user_id: @current_user.id, room_id: @room_id)
    Entry.create(user_id: @user.id, room_id: @room_id)
    redirect_to "/rooms/#{@room_id}?user_id=#{@user.id}"
  end

  def index
    @users = @current_user.dm_members
  end
end
