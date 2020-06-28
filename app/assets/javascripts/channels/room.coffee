App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
  
  disconnected: ->

  rejected: ->

  received: (data) ->
    if data['room_id'] isnt undefined && data['message'] isnt undefined # メッセージ追加 = room_idとmessageあり
      url = location.pathname
      browser_room_id = url.split('/rooms/').pop()
      message_room_id = data['room_id'].toString()
      if browser_room_id == message_room_id # 開いているページとroom_idが一致した場合にのみ更新される
        if data['flag'] == "my"
          $('.latest-message').append data['message']
        if data['flag'] == "other"
          $('.latest-message').append data['message']
          
    if data['room_id'] isnt undefined && data['flag'] == "read" # 既読処理 = room_idとflagが"read"
      url = location.pathname
      browser_room_id = url.split('/rooms/').pop()
      message_room_id = data['room_id'].toString()
      if browser_room_id == message_room_id # 開いているページとroom_idが一致した場合にのみ更新される
        $('.unread').each ->
          $(this).text('既読')
        
    if data['message_id'] isnt undefined # メッセージ削除 = messages_idあり
      $("#message-#{data['message_id']}").remove()
        
  speak: (message) ->
    url = location.pathname
    room_id = url.split('/rooms/').pop()
    @perform 'speak', message: message, room_id: room_id
    
  destroy: (message_id) ->
    @perform 'destroy', message_id: message_id
  
  # 決定ボタンクリック時
  $(document).on 'click', '.speak-btn', (event) ->
    text = $('#room-speaker').val()
    App.room.speak text.replace(/\n{2,}/g,'\n') # 空文(改行2連続以上)を取り除く
    $('#room-speaker').val('')
    
  # 削除ボタンクリック時
  $(document).on 'click', '.delete-btn', (event) ->
    App.room.destroy event.target.id
