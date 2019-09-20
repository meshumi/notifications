#= require jquery
#= require jqueryui
#= require jquery_ujs
#= require bootstrap-sprockets
#= require active_admin/base
#= require summernote
#= require summernote/summernote-ext-video
#  https://github.com/punkave/sanitize-html
#= require summernote/sanitize-html
#= require tagsinput
#= require active_admin_datetimepicker

$ ->
  $('#tags').tagsInput
    width: 'auto'
    height: 'auto'
    defaultText: ''
    removeWithBackspace: false
    autocomplete_url: '/tags'

  # Editor ------------------------------------------------------------------------------------------------------------
  $('.editor').summernote
    height: 500
    disableResizeEditor: true
    focus: true
    tabsize: 2
    styleTags: ['p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'pre'],
    toolbar: [
      ['style', ['style']]
      ['font', ['bold', 'italic', 'underline', 'clear']]
      ['para', ['ul', 'ol', 'paragraph']]
      ['table', ['table']]
      ['insert', ['link', 'hr']]
#      ['insert', ['link', 'picture', 'video', 'hr']]
      ['view', ['fullscreen', 'codeview']]
    ]
    onPaste: (e) ->
      e.preventDefault()

      bufferText = ((e.originalEvent || e).clipboardData || window.clipboardData).getData('text/html')

      sanitizedText = sanitizeHtml bufferText,
        allowedTags: ['iframe', 'img', 'blockquote', 'p', 'a', 'ul', 'ol', 'li', 'b', 'strong', 'code', 'hr', 'br', 'table', 'thead', 'caption', 'tbody', 'tr', 'th', 'td', 'pre']
        allowedAttributes:
          a: ['href', 'target']
          img: ['src']
          iframe: ['src', 'width', 'height', 'frameborder', 'allowfullscreen']
        selfClosing: ['img', 'br', 'hr', 'input', 'meta']
        nonTextTags: ['style', 'script', 'textarea', 'noscript']
        allowedSchemes: ['http', 'https']
        allowedSchemesByTag: {}
        transformTags:
          'h1': 'p'
          'h2': 'p'
          'h3': 'p'
          'h4': 'p'
          'h5': 'p'
          'h6': 'p'
        parser:
          lowerCaseTags: true

      bufferText = ((e.originalEvent or e).clipboardData or window.clipboardData).getData('Text')

      document.execCommand('insertHtml', false, sanitizedText || bufferText)
    onImageUpload: (files) ->
      $note = $(this)

      data = new FormData()

      $.each files, (key, value) ->
        data.append 'files[]', value

      $.ajax
        url: '/file/upload'
        data: data
        type: 'POST'
        cache: false
        dataType: 'json'
        contentType: false
        processData: false
        success: (response, textStatus, jqXHR) ->
          $note.summernote 'insertNode', $('<img>', { src: response.url, alt: '' })[0]

#  new AvatarCropper()
#
#class AvatarCropper
#  constructor: ->
#    $('#cropbox').Jcrop
#      aspectRatio: 1
#      setSelect: [0, 0, 600, 600]
#      onSelect: @update
#      onChange: @update
#
#  update: (coords) =>
#    $('#post_crop_x').val(coords.x)
#    $('#post_crop_y').val(coords.y)
#    $('#post_crop_w').val(coords.w)
#    $('#post_crop_h').val(coords.h)
#    @updatePreview(coords)
#
#  updatePreview: (coords) =>
#    $('#preview').css
#      width: Math.round(100/coords.w * $('#cropbox').width()) + 'px'
#      height: Math.round(100/coords.h * $('#cropbox').height()) + 'px'
#      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
#      marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'

