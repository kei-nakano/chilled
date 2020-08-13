class MessageHiddenJob < ApplicationJob
  queue_as :default

  def perform(tmp_deleted_message)
    message_id = tmp_deleted_message.message_id
    # クライアント側の画面から、削除ボタンを押したメッセージを消去するよう配信する
    ActionCable.server.broadcast "user_#{tmp_deleted_message.user_id}", message_id: message_id

    # TmpDeletedMessageに削除対象メッセージが2件登録されている => 自分も相手も「削除」の判断をしたメッセージなので、DBから削除する
    Message.find(message_id).destroy! if TmpDeletedMessage.where(message_id: message_id).count == 2
  end
end
