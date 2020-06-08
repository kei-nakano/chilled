App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
  
  disconnected: ->
    
  rejected: ->

  received: (data) ->
    url = location.pathname
    browser_room_id = url.split('/room/').pop()
    message_room_id = data['room_id'].toString()
    if browser_room_id == message_room_id
      if data['flag'] == "my"
        $('.latest-message').append data['message']
      if data['flag'] == "other"
        $('.latest-message').append data['message']
        
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