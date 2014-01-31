module Reform
  class Form
    include Reform::Form::ActiveRecord
    include Reform::Form::ActiveModel
    include Reform::Form::ActiveModel::FormBuilderMethods

    property :id

    module ValidateMethods # TODO: introduce Base module.
      def validate(params)
        # here it would be cool to have a validator object containing the validation rules representer-like and then pass it the formed model.
        from_hash(params)

        is_valid = true
        is_valid &= valid?
        is_valid &= validate_for @fields, params, is_valid
        is_valid
      end

    private

      def validate_for fields, params, is_valid
        fields.to_h.each do |column, form|
          if params && form.respond_to?('valid?')
            # lets save the data to the nested form
            if (nested_params = params[column])
              nested_params = Hash[nested_params.map { |k, v| [k.gsub(/_attributes/, '').to_sym, v] }]

              current_params = nested_params.reject { |key, value| value.kind_of?(Hash) ? true : false }

              if current_params.any?
                unless current_params.length == 1 && current_params.first.first == :id
                  form.from_hash params[column]
                  is_valid &= form.valid?
                  errors.merge!(form.errors, column)
                end
              else
                is_valid &= validate_for form.send(:fields), nested_params, is_valid
              end
            end
          end
        end

        is_valid
      end
    end

    def save_as current_user, &block
      form = self

      save do |data, nested|
        nested = nested.with_indifferent_access

        block.call nested, data if block
        model.attributes = append_attributes nested
        add_creator_and_updater_for model, current_user, nested
        model.save!
        form.id = model.id unless form.id
      end
    end

    def append_attributes params
      params.clone.each do |key, value|
        if value.kind_of? Hash
          new_attributes = append_attributes(params[key])
          unless key.include? '_attributes'
            params["#{key}_attributes"] = new_attributes unless new_attributes.empty?
            params.delete key
          end
        end
      end

      params
    end

    def add_creator_and_updater_for(model, current_user = nil, current_params = @params)
      model.attributes.each do |name, value|
        if (name == "creator_id" && model.new_record?) || name == "updater_id"
          id = current_user.try(:id) || ENV["SYSTEM_USER_ID"]
          model.set_unrestricted_attribute(name, id)

          next
        end

        if name.end_with?("_id")
          name_without_id   = name[0..-4]
          associated_model  = model.try(name_without_id)

          if associated_model.kind_of? ::ActiveRecord::Base
            new_current_params = current_params[name_without_id]

            if new_current_params.kind_of? Hash
              add_creator_and_updater_for associated_model, current_user, new_current_params
            end
          end
        end
      end
    end

    def validate params
      # So we can access the params passed, in other methods
      @params = params
      super params
    end

    class << self
      def reflect_on_association field
        Object::const_get(model_name.to_s.classify).reflect_on_association field
      end
    end

  private

    module Setup
      module Representer
      private
        def setup_nested_forms
          nested_forms do |attr, model|
            form_class = attr.options[:form]

            attr.options.merge!(
              :getter   => lambda do |*|
                nested_model  = send(attr.getter) || attr.options[:model].try(:new) # decorated.hit # TODO: use bin.get

                if attr.options[:form_collection]
                  Forms.new(nested_model.collect { |mdl| form_class.new(mdl)})
                else
                  form_class.new(nested_model)
                end
              end,
              :instance => false, # that's how we make it non-typed?.
            )
          end
        end
      end
    end
  end
end

# For backwards compatibility
class Powertools::Reform < Reform::Form
end
