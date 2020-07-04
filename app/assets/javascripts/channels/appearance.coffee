App.appearance = App.cable.subscriptions.create "AppearanceChannel",
  connected: ->

  disconnected: ->

  appear: (room_id) ->
    @perform 'appear', room_id: room_id

  $(document).on "turbolinks:load.appearnace", =>
    url = location.pathname
    room_id = url.split('/rooms/').pop()
    if $.isNumeric Number(room_id) 
      App.appearance.appear room_id
    else 
      App.appearance.appear 0 # 0はどのroomにも入っていないことを表す
      