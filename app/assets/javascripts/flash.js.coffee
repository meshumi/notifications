$ ->
  window.flash = new FleshAlert();

  hide_permanent_flash = ->
    $('.alert-permanent')
      .addClass('hidden')
      .removeClass('alert-success')
      .removeClass('alert-danger')
    $('.alert-permanent').find('.message').html('')

  setTimeout(hide_permanent_flash, 7000);

class FleshAlert
  constructor: ->
    @container = $('.alert-container')

  error: (text)->
    @show('alert-danger', text)

  success: (text) ->
    @show('alert-success', text)

  info: (text)->
    @show('alert-info', text)

  show: (status, text)->
    @renew(status)
    @container.find('.message').html(text)
    @container.addClass(status)
    @container.removeClass('hidden')
    setTimeout((=> @renew(status)), 7000)

  renew: (status)->
    @container.addClass('hidden').removeClass(status);
    @container.find('.message').html('');
