removeFirstButton = ->
  $('[pt-dupe-form]').each ->
    $form      = $(this)
    formName   = $form.attr 'pt-dupe-form'
    $firstForm = $(document).find("[pt-dupe-form=\"#{formName}\"]:first")
    # Hide remove button from first form
    $firstForm.find('[pt-dupe-remove]').hide()
tags =
  ready:
    event: 'bind'
    callback: removeFirstButton

  'page:change':
    event: 'bind'
    callback: removeFirstButton

  dupeAdd:
    event: 'click'
    callback: (event) ->
      event.preventDefault()

      $link      = $(this)
      formName   = $link.attr 'pt-dupe-add'
      $forms     = $("[pt-dupe-form=\"#{formName}\"]")
      $formClone = $forms.first().clone()
      formCount  = $forms.length

      if $formClone
        # Clean out the inputs
        $formClone.find(':input').each ->
          $input = $(this)
          switch @type
            when 'password'
            , 'text'
            , 'textarea'
              # Clear value
              $input.val ''
            when 'select-one', 'select-multiple'
              $input.find('option').removeAttr 'selected'
            when 'checkbox', 'radio'
              @checked = false

          # Update id
          if attrId = $input.attr 'id'
            $input.attr 'id', $input.attr('id').replace(/_[0-9]+_/, "_#{formCount}_")

          # Update name
          if attrId = $input.attr 'name'
            $input.attr 'name', $input.attr('name').replace(/\[[0-9]+\]/, "[#{formCount}]")

        # Update Label for
        $formClone.find('label').each ->
          $label = $(this)
          if attrFor = $label.attr('for')
            $label.attr 'for', attrFor.replace(/_[0-9]+_/, "_#{formCount}_")

        # Update index
        if ($index = $formClone.find('[pt-dupe-index]')) and (html = $index.html())
          $index.html html.replace(/\s[0-9]+/, " #{formCount + 1}")

        # Show remove button
        $formClone.find('[pt-dupe-remove]').show()

        # Add the form to the dom
        $forms.last().after $formClone

  dupeRemove:
    event: 'click'
    callback: (event) ->
      $link      = $(this)
      href       = $link.attr 'href'
      formName   = $link.attr 'pt-dupe-remove'
      $form      = $link.closest "[pt-dupe-form=\"#{formName}\"]"
      $form.remove()

      event.preventDefault() unless href.length

window.pt ||= tags: []
for name, tag of tags
  newTag = {}
  newTag[name] = tag
  window.pt.tags.push newTag
