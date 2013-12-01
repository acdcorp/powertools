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
                helper.capture_haml 'div', {}, &block
              end
            end
          end
        end
      end
    end
  end
end
