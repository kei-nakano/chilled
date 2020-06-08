App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    console.log(location.pathname)
  
  disconnected: ->
    @perform 'unsubscribed'
    
  rejected: ->
    @perform 'unsubscribed'
    console.log(location.pathname)

  # サーバからデータを受信した時の処理
  received: (data) ->
    $('.latest-message').append data['message']
    console.log('受信')

  # サーバのspeakアクションを呼び出すための処理
  speak: (message) ->
    url = location.pathname
    room_id = url.split('/room/').pop()
    @perform 'speak', message: message, room_id: room_id

  #　------あとで------
  # クライアント側の動作で、speakメソッドを起動するための処理
  $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
    if event.keyCode is 13 # 13はenterキーが押された場合
      App.room.speak event.target.value
      event.target.value = ''
      event.preventDefault()