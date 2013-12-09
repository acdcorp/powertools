module PtUiHelper
  def html &block
    r = Object.new
    r.extend Mab::Mixin::HTML5
    r.extend Mab::Indentation
    content = r.mab(&block)
    raw content
  end

  def pt_page_header title, options = {}
    helper = self
    options = options.with_indifferent_access

    html do
      div do
        helper.render partial: 'layouts/breadcrumbs'
      end
      div class: 'page-header' do
        if title
          div class: 'page-title' do
            h3 do
              if options.key? :icon
                i class: "icon-#{options[:icon]}"
              end
              text title
              if options.key? :sub_text
                span do
                  text options[:sub_text]
                end
              end
            end
          end
        end
      end
    end
  end

  def pt_box options = {}, &block
    helper = self

    html do
      div class: 'row', id: options[:id] do
        div class: 'col-md-12' do
          div class: 'widget box' do
            if options.key? :header
              div class: 'widget-header' do
                h4 do
                  if options.key? :icon
                    i class: "icon-#{options[:icon]}"
                  end
                  text options[:header]
                end
              end
            end
            div class: "widget-content #{options.key?(:no_padding) ? 'no-padding' : ''}" do
              div class: 'row-fluid' do
                html helper.capture_haml 'div', {}, &block
              end
            end
          end
        end
      end
    end
  end

  def pt_wizard_for form_object, options = {}, &block
    options[:html] ||= { class: 'form-horizontal', 'pt-remote' => true }

    content       = OpenStruct.new
    content.step  = 1
    content.steps = []

    sf = simple_form_for form_object, html: { class: 'form-horizontal', 'pt-remote' => true } do |form|
      yield form, content
    end

    options[:html][:action] = sf.scan(/<form.+?action="(.+?)"/).first.first
    options[:html][:method] = sf.scan(/<form.+?method="(.+?)"/).first.first

    html do
      div class: 'col-md-12' do
        div class: 'form-horizontal' do
          div id: 'form_wizard', class: 'widget box' do
            # Add a title if we have one
            if options[:title]
              div class: 'widget-header' do
                h4 do
                  i class: 'icon-reorder' do
                    text options[:title]
                    span(class: 'step-title') { "Step #{content.step} of #{content.steps.length}" }
                  end
                end
              end
            end
            ############################
            div class: 'wizard-content' do
              div class: 'form-wizard' do
                form options[:html] do
                  div class: 'form-body' do
                    ul class: 'nav nav-pills nav-justified steps' do
                      content.steps.each_with_index do |step, index|
                        li class: ('active' if index+1 == active) do
                          div class: 'step' do
                            span class: 'number' do
                              text index + 1
                            end
                            span class: 'desc' do
                              i class: 'icon-ok'
                            end
                          end
                          text step
                        end
                      end
                    end
                    div id: 'bar',  class: 'progress progress-stripped active', role: 'progressbar' do
                      div class: 'progress-bar progress-bar-success', style: "width: #{((active.to_f-1)/steps.length.to_f*100).to_i}%"
                    end
                    div class: 'tab-content' do
                      text! content.body
                    end
                  end
                  div class: 'form-actions fluid' do
                    div class: 'row' do
                      div class: 'col-md-12' do
                        div class: 'col-md-offset-2 col-md-10' do
                          text! content.footer
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
