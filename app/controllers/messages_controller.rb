class MessagesController < ApplicationController
  def create
    @message = Message.new(user_id: @current_user.id, room_id: params[:room_id], content: params[:message][:content])
    @message.save
    @room_id = params[:room_id]
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.js
    end
  end
end
