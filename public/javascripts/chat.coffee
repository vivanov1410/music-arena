socket = io.connect  window.location.hostname

socket.on 'connect', ->
  socket.emit 'adduser', $('#username').val()

socket.on 'updatechat', (username, data) ->
  $('#conversation').append '<b>' + username + ':</b> ' + data + '<br>'

socket.on 'updateusers', (data) ->
  $('#users').empty()
  $.each data, (key, value) ->
    $('#users').append '<div>' + key + '</div>'

$ ->
    $('#datasend').click ->
        message = $('#data').val()
        $('#data').val ''
        socket.emit 'sendchat', message

    $('#data').keypress (e) ->
        if e.which is 13
            $(this).blur()
            $('#datasend').focus().click()