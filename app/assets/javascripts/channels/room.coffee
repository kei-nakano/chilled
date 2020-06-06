App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
  
  disconnected: ->

  # サーバからデータを受信した時の処理
  received: (data) ->
    $('#messages').append data['message']

  # サーバのspeakアクションを呼び出すための処理
  speak: (message) ->
    url = location.pathname
    room_id = url.split('/room/').pop()
    users_path = url.split('/room/').shift()
    user_id = users_path.split('users/').pop()
    @perform 'speak', message: message, user_id: user_id, room_id: room_id

  # クライアント側の動作で、speakメソッドを起動するための処理
  $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
    if event.keyCode is 13 # 13はenterキーが押された場合
      App.room.speak event.target.value
      event.target.value = ''
      event.preventDefault()
