window.pt ||= tags: []

pt.tags.push
  remote:
    event: 'submit'
    callback: (event) ->
      $el        = $ this
      attr       = $el.ptAttr()

      unless $el.data 'ptRemoteSending'
        addHtml = (html) ->
          if attr.remoteContainer
            $(attr.remoteContainer).html html
          else
            $el.parent().html html
          $(document).trigger 'page:change'
        $(this).ajaxSubmit
          success: (html, responseText, xhr) ->
            unless (type = xhr.getResponseHeader("content-type").match('text/javascript')) && type.length
              addHtml html
          error: (response, status) ->
            switch response.status
              # This error code just means the didn't send all required fields,
              # so just render the html
              when 406
                addHtml response.responseText
              else
                log '[c="color: red"]PT REMOTE ERROR:[c]'
                log response.statusText, response
        return false
