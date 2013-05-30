window.pt ||= tags: []

pt.tags.push
  confirm:
    event: 'click'
    callback: ->
      $el  = $ this
      attr = $el.ptAttr()
      url  = attr.confirm

      $el.data 'ptConfirmLoaded', true

      buttons = [
        {
          label: 'Yes'
          class: 'btn-primary'
          callback: ->
            $.ajax
              url: url
              type: 'DELETE'
              success: ->
                $('#pt-modal-body').closest('.bootbox').modal('hide')
        }
        {
          label: 'Cancel'
          callback: -> $('#pt-modal-body').closest('.bootbox').modal('hide')
        }
      ]

      $bootbox = bootbox.dialog false, buttons, { header: attr.confirmTitle or 'Are you sure?', keyboard: true  }
      $bootbox.find('.modal-body').remove()
      $bootbox.find('.modal-footer a:last').removeClass 'btn-primary'
