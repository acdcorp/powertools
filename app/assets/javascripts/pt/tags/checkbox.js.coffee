window.pt ||= tags: []

pt.tags.push
  checkboxAll:
    event: 'click'
    callback: ->
      $el          = $ this
      attr         = $el.ptAttr()
      checkboxName = attr.checkboxAll
      isChecked    = $el.is ':checked'
      checkBoxes   = $("[pt-checkbox-wrap='#{checkboxName}']:visible [pt-checkbox='#{checkboxName}']")

      checkBoxes.prop 'checked', isChecked

  checkboxAction:
    event: 'click'
    callback: (e) ->
      e.preventDefault()
      $el          = $ this
      attr         = $el.ptAttr()
      checkboxName = attr.checkboxAction
      isChecked    = $el.is ':checked'
      checkBoxes   = $("[pt-checkbox-wrap='#{checkboxName}']:visible [pt-checkbox='#{checkboxName}']:checked")
      url          = $el.attr 'href'
      ids          = []

      checkBoxes.each (i, checkbox) -> ids.push $(checkbox).attr 'pt-checkbox-id'

      $.ajax
        url: url
        type: 'PUT'
        data:
          ids: ids
