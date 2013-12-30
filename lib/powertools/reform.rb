class Powertools::Reform < Reform::Form
  include Reform::Form::ActiveModel
  include Reform::Form::ActiveModel::FormBuilderMethods

  def save_as current_user
    save
    add_creator_and_updater_for model, current_user
    model.save!
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
end
