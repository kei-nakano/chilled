class RoomsController < ApplicationController
  before_action :authenticate_user

  def show
    @room = Room.find(params[:id])
    @user = User.find(params[:user_id]) # トーク相手
    block_ids = @current_user.block_ids
    if block_ids.include?(@user.id)
      flash[:notice] = "このユーザをブロックしているかブロックされているため、メッセージを送ることができません。"
      redirect_back(fallback_location: "/users/#{@user.id}")
    end

    # roomに入った時点で、もし存在していれば、その相手ユーザとのroomに紐づくHiddenRoomを削除する
    HiddenRoom.find_by(user_id: @current_user.id, room_id: @room.id)&.destroy

    # roomに入った時点で、未読メッセージのステータスを全て既読に変更する
    # view側で自分のメッセージが相手のメッセージが振り分ける。ここではトーク内の全メッセージを取得する
    @messages = Message.includes(:user).where(room_id: @room.id)

    # 既読処理
    unread_messages = @messages.where(checked: false, user_id: @user.id)
    unread_messages.each do |message|
      message.update_attribute(:checked, true)
    end
    MessageStatusChangeJob.perform_later @room.id, @user.id # メッセージ送信者の画面をJob経由で更新する
  end

  def create
    @room_id = Room.create.id
    @user = User.find(params[:user_id])
    Entry.create(user_id: @current_user.id, room_id: @room_id)
    Entry.create(user_id: @user.id, room_id: @room_id)
    redirect_to "/rooms/#{@room_id}?user_id=#{@user.id}"
  end

  def index
    # 過去にトークルームを作成したことがない場合は、全ユーザを表示する
    talked_users = @current_user.dm_members
    @users = talked_users.where.not(id: @current_user.hidden_user_ids)
  end
end
