App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
  
  disconnected: ->
    
  rejected: ->

  received: (data) ->
    if data['room_id'] isnt undefined
      url = location.pathname
      browser_room_id = url.split('/room/').pop()
      message_room_id = data['room_id'].toString()
      if browser_room_id == message_room_id
        if data['flag'] == "my"
          $('.latest-message').append data['message']
        if data['flag'] == "other"
          $('.latest-message').append data['message']
          
    if data['message_id'] isnt undefined
      $("#message-#{data['message_id']}").remove()
        
  speak: (message) ->
    url = location.pathname
    room_id = url.split('/room/').pop()
    @perform 'speak', message: message, room_id: room_id
    
  destroy: (message_id) ->
    @perform 'destroy', message_id: message_id

  $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
    if event.keyCode is 13 # 13はenterキーが押された場合
      App.room.speak event.target.value
      event.target.value = ''
      event.preventDefault()
      
  $(document).on 'click', '.delete-btn', (event) ->
    App.room.destroy event.target.id
