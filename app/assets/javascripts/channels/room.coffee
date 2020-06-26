App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
  
  disconnected: ->
    
  rejected: ->

  received: (data) ->
    if data['room_id'] isnt undefined
      url = location.pathname
      browser_room_id = url.split('/rooms/').pop()
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
    room_id = url.split('/rooms/').pop()
    @perform 'speak', message: message, room_id: room_id
    
  destroy: (message_id) ->
    @perform 'destroy', message_id: message_id

  $(document).on 'click', '.speak-btn', (event) ->
    text = $('#room-speaker').val()
    App.room.speak text.replace(/\n{2,}/g,'\n') # 空文を取り除く
    $('#room-speaker').val('')
    
  $(document).on 'click', '.delete-btn', (event) ->
    App.room.destroy event.target.id
