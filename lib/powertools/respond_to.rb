module Powertools::RespondTo
  extend ActiveSupport::Concern

  def pt_respond_to *resources, &block
    options = resources.extract_options!
    old_block = block
    block = lambda do |format|
      if options[:partials] and partial = params_contain_partial(options[:partials] || [])
        case File.extname(partial[:template])
        when ".js"
          format.js { render partial: partial[:template] }
        else
          format.html { render partial: partial[:template] }
        end
      else
        old_block.call(format) if block_given?
      end
    end
    respond_to(&block)
  end

  private

  def params_contain_partial partials
    selected_partial = false
    partials.each do |partial|
      selected_partial = partial if partial[:name] == params[:partial]
    end
    selected_partial
  end
end
