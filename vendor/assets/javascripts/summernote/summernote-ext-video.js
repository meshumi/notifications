(function (factory) {
  /* global define */
  if (typeof define === 'function' && define.amd) {
    // AMD. Register as an anonymous module.
    define(['jquery'], factory);
  } else {
    // Browser globals: jQuery
    factory(window.jQuery);
  }
}(function ($) {
  // template
  var tmpl = $.summernote.renderer.getTemplate();

  // core functions: range, dom
  var range = $.summernote.core.range;
  var dom = $.summernote.core.dom;

  /**
   * createVideoNode
   *
   * @member plugin.video
   * @private
   * @param {String} url
   * @return {Node}
   */
  var createVideoNode = function (url) {
    // video url patterns(youtube, instagram, vimeo, dailymotion, youku, mp4, ogg, webm)
    var ytRegExp = /^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$/;
    var ytMatch = url.match(ytRegExp);

    var igRegExp = /\/\/instagram.com\/p\/(.[a-zA-Z0-9]*)/;
    var igMatch = url.match(igRegExp);

    var vRegExp = /\/\/vine.co\/v\/(.[a-zA-Z0-9]*)/;
    var vMatch = url.match(vRegExp);

    var vimRegExp = /\/\/(player.)?vimeo.com\/([a-z]*\/)*([0-9]{6,11})[?]?.*/;
    var vimMatch = url.match(vimRegExp);

    var dmRegExp = /.+dailymotion.com\/(video|hub)\/([^_]+)[^#]*(#video=([^_&]+))?/;
    var dmMatch = url.match(dmRegExp);

    var youkuRegExp = /\/\/v\.youku\.com\/v_show\/id_(\w+)\.html/;
    var youkuMatch = url.match(youkuRegExp);

    var mp4RegExp = /^.+.(mp4|m4v)$/;
    var mp4Match = url.match(mp4RegExp);

    var oggRegExp = /^.+.(ogg|ogv)$/;
    var oggMatch = url.match(oggRegExp);

    var webmRegExp = /^.+.(webm)$/;
    var webmMatch = url.match(webmRegExp);

    var $video;

    if (ytMatch && ytMatch[1].length === 11) {
      var youtubeId = ytMatch[1];
      var options = '?&theme=light&color=white&autohide=1&modestbranding=1&showinfo=0&iv_load_policy=3';
      $video = $('<iframe>', { class: 'video' })
        .attr('src', '//www.youtube.com/embed/' + youtubeId + options)
        .attr('width', '640').attr('height', '390').attr('frameborder', '0').attr('allowfullscreen', 'true');
    } else if (igMatch && igMatch[0].length) {
      $video = $('<iframe>', { class: 'video' })
        .attr('src', igMatch[0] + '/embed/')
        .attr('width', '612').attr('height', '710')
        .attr('scrolling', 'no')
        .attr('allowtransparency', 'true');
    } else if (vMatch && vMatch[0].length) {
      $video = $('<iframe>', { class: 'video' })
        .attr('src', vMatch[0] + '/embed/simple')
        .attr('width', '600').attr('height', '600')
        .attr('class', 'vine-embed');
    } else if (vimMatch && vimMatch[3].length) {
      $video = $('<iframe webkitallowfullscreen mozallowfullscreen allowfullscreen>', { class: 'video' })
        .attr('src', '//player.vimeo.com/video/' + vimMatch[3])
        .attr('width', '640').attr('height', '360');
    } else if (dmMatch && dmMatch[2].length) {
      $video = $('<iframe>', { class: 'video' })
        .attr('src', '//www.dailymotion.com/embed/video/' + dmMatch[2])
        .attr('width', '640').attr('height', '360');
    } else if (youkuMatch && youkuMatch[1].length) {
      $video = $('<iframe webkitallowfullscreen mozallowfullscreen allowfullscreen>', { class: 'video' })
        .attr('height', '498')
        .attr('width', '510')
        .attr('src', '//player.youku.com/embed/' + youkuMatch[1]);
    } else if (mp4Match || oggMatch || webmMatch) {
      $video = $('<video controls>')
        .attr('src', url)
        .attr('width', '640').attr('height', '360');
    } else {
      // this is not a known video link. Now what, Cat? Now what?
      return false;
    }

    var $container = $('<div>', { class: 'video-container' });

    $container.append($video);

    return $container[0];
  };

  /**
   * @member plugin.video
   * @private
   * @param {jQuery} $editable
   * @return {String}
   */
  var getTextOnRange = function ($editable) {
    $editable.focus();

    var rng = range.create();

    // if range on anchor, expand range with anchor
    if (rng.isOnAnchor()) {
      var anchor = dom.ancestor(rng.sc, dom.isAnchor);
      rng = range.createFromNode(anchor);
    }

    return rng.toString();
  };

  /**
   * toggle button status
   *
   * @member plugin.video
   * @private
   * @param {jQuery} $btn
   * @param {Boolean} isEnable
   */
  var toggleBtn = function ($btn, isEnable) {
    $btn.toggleClass('disabled', !isEnable);
    $btn.attr('disabled', !isEnable);
  };

  /**
   * Show video dialog and set event handlers on dialog controls.
   *
   * @member plugin.video
   * @private
   * @param {jQuery} $dialog
   * @param {jQuery} $dialog
   * @param {Object} text
   * @return {Promise}
   */
  var showVideoDialog = function ($editable, $dialog, text) {
    return $.Deferred(function (deferred) {
      var $videoDialog = $dialog.find('.note-video-dialog');

      var $videoUrl = $videoDialog.find('.note-video-url'),
          $videoBtn = $videoDialog.find('.note-video-btn');

      $videoDialog.one('shown.bs.modal', function () {
        $videoUrl.val(text).on('input', function () {
          toggleBtn($videoBtn, $videoUrl.val());
        }).trigger('focus');

        $videoBtn.click(function (event) {
          event.preventDefault();

          deferred.resolve($videoUrl.val());
          $videoDialog.modal('hide');
        });
      }).one('hidden.bs.modal', function () {
        $videoUrl.off('input');
        $videoBtn.off('click');

        if (deferred.state() === 'pending') {
          deferred.reject();
        }
      }).modal('show');
    });
  };

  /**
   * @class plugin.video
   *
   * Video Plugin
   *
   * video plugin is to make embeded video tag.
   *
   * ### load script
   *
   * ```
   * < script src="plugin/summernote-ext-video.js"></script >
   * ```
   *
   * ### use a plugin in toolbar
   * ```
   *    $("#editor").summernote({
   *    ...
   *    toolbar : [
   *        ['group', [ 'video' ]]
   *    ]
   *    ...
   *    });
   * ```
   */
  $.summernote.addPlugin({
    /** @property {String} name name of plugin */
    name: 'video',
    /**
     * @property {Object} buttons
     * @property {function(object): string} buttons.video
     */
    buttons: {
      video: function (lang) {
        return tmpl.iconButton('fa fa-youtube-play', {
          event: 'showVideoDialog',
          title: lang.video.video,
          hide: true
        });
      }
    },

    /**
     * @property {Object} dialogs
     * @property {function(object, object): string} dialogs.video
    */
    dialogs: {
      video: function (lang) {
        var body = '<div class="form-group row-fluid">' +
                     '<label>' + lang.video.url + '</label>' +
                     '<input class="note-video-url form-control span12" type="text" />' +
                     '<br /><small class="text-muted">' + lang.video.providers + '</small>' +
                   '</div>';
        var footer = '<button href="#" class="btn btn-primary note-video-btn disabled" disabled>' + lang.video.insert + '</button>';
        return tmpl.dialog('note-video-dialog', lang.video.insert, body, footer);
      }
    },
    /**
     * @property {Object} events
     * @property {Function} events.showVideoDialog
     */
    events: {
      showVideoDialog: function (event, editor, layoutInfo) {
        var $dialog = layoutInfo.dialog(),
            $editable = layoutInfo.editable(),
            text = getTextOnRange($editable);

        // save current range
        editor.saveRange($editable);

        showVideoDialog($editable, $dialog, text).then(function (url) {
          // when ok button clicked

          // restore range
          editor.restoreRange($editable);

          // build node
          var $node = createVideoNode(url);

          if ($node) {
            // insert video node
            editor.insertNode($editable, $node);
          }
        }).fail(function () {
          // when cancel button clicked
          editor.restoreRange($editable);
        });
      }
    },

    // define language
    langs: {
      'en-US': {
        video: {
          video: 'Video',
          videoLink: 'Video Link',
          insert: 'Insert Video',
          url: 'Video URL?',
          providers: '(YouTube, Vimeo, Vine, Instagram, DailyMotion or Youku)'
        }
      },
      'ru-RU': {
        video: {
          video: 'Видео',
          videoLink: 'Ссылка на видео',
          insert: 'Вставить видео',
          url: 'URL видео',
          providers: '(YouTube, Vimeo, Vine, Instagram, DailyMotion или Youku)'
        }
      }
    }
  });
}));
