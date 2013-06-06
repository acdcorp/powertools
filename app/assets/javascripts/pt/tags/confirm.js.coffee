window.pt ||= tags: []

pt.tags.push
  confirmDelete:
    event: 'click'
    callback: ->
      $el  = $confirmContainer  = $ this
      attr = $el.ptAttr()
      url  = attr.confirmDelete

      if attr.confirmContainer
        $confirmContainer = $el.closest(attr.confirmContainer)

      unless $el.data 'ptConfirmLoaded'
        $el.data 'ptConfirmLoaded', true

        $html = $ '<div>',
          style: 'text-align: center;'

        $deleteButton = $ '<button>',
          class: 'btn btn-danger delete'
          style: 'margin-right: 10px;'
          text: 'Delete'
        $html.append $deleteButton

        $cancelButton = $ '<button>',
          class: 'btn cancel'
          text: 'Cancel'
        $html.append $cancelButton

        $confirmContainer.on 'click', '.popover-content .delete', ->
          $.ajax
            url: url
            type: 'DELETE'
            success: ->
              $confirmContainer.popover 'hide'

        $confirmContainer.on 'click', '.popover-content .cancel', ->
          $confirmContainer.popover 'hide'

        $confirmContainer.popover
          content: $html
          html: true
          trigger: 'manual'
          title: attr.confirmTitle or 'Are you sure you want to delete?'
          placement: attr.confirmPlacement or 'right'
          container: $confirmContainer

      $confirmContainer.popover 'show'
#
#       buttons = [
#         {
#           label: 'Yes'
#           class: 'btn-primary'
#           callback: ->
#             $.ajax
#               url: url
#               type: 'DELETE'
#               success: ->
#                 $('#pt-modal-body').closest('.bootbox').modal('hide')
#         }
#         {
#           label: 'Cancel'
#           callback: -> $('#pt-modal-body').closest('.bootbox').modal('hide')
#         }
#       ]
#
#       $bootbox = bootbox.dialog false, buttons, { header: attr.confirmTitle or 'Are you sure?', keyboard: true  }
#       $bootbox.find('.modal-body').remove()
#       $bootbox.find('.modal-footer a:last').removeClass 'btn-primary'
