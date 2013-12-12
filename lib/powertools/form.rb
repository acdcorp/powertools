class Powertools::Form
  include ActiveModel::Model
  include Hooks

  define_hooks :before_initialize, :initialize, :before_submit, :before_validation, :before_forms_save, :before_create, :before_save, :after_save, :after_create

  attr_accessor :model, :store, :params, :options, :current_user

  def store
    self.class.store ||= {}
  end

  def inherit_stores_from_parent_class check_class
    if check_class.superclass.name != 'PowertoolsForm'
      # We need to merge the parent classes store
      if check_class.superclass.respond_to? :store
        parent_store  = check_class.superclass.store
        # Loop through the parent store and merge in the store
        parent_store.each do |key, data|
          if store.key?(key) && store[key][:type] == :model
            store[key][:fields].concat(data[:fields]).uniq!
          else
            store[key] = data
          end
        end
        inherit_stores_from_parent_class check_class.superclass
      end
    end
  end

  def initialize current_user, current_model = false, *options
    @current_user = current_user
    @model        = current_model
    @options      = options.extract_options!
    # This is so simple form knows how to set the correct name
    # for the submit button. i.e. create or edit
    @persisted = (@model.respond_to?(:id) && @model.id) ? :edit : false

    run_hook :before_initialize

    # Do things with the parent class
    inherit_stores_from_parent_class self.class

    # Load data into models if any is sent
    store.each do |store_key, current_store|
      case current_store[:type]
      when :model
        if @model && current_store[:class] == @model.class.name
          add_method @model
        else
          @model = Object::const_get(current_store[:class]).new
          add_method @model
        end
      when :form
        if @model && @model.respond_to?(store_key)
          form = Object::const_get(current_store[:class]).new current_user, @model.send(store_key)
          add_method form, store_key
        end
      end
    end

    # For displaying the fields in simple_form
    add_inputs_as

    run_hook :initialize
  end

  def persisted?
    @persisted
  end

  def add_inputs_as
    store.each do |store_key, current_store|
      if current_store.key? :inputs_as
        main_object = self
        current_store[:inputs_as].each do |field, block|
          if current_store[:type] == :model
            self.metaclass.send(:define_method, "#{field}_input") do
              type = main_object.instance_eval(&block)
              Powertools::FormInput.new type if type
            end
          else
            send(store_key).metaclass.send(:define_method, "#{field}_input") do
              type = main_object.instance_eval(&block)
              Powertools::FormInput.new type if type
            end
          end
        end
      end
    end
  end

  # http://codeblog.dhananjaynene.com/2010/01/dynamically-adding-methods-with-metaprogramming-ruby-and-python/
  def metaclass
    class << self; self; end
  end

  def add_method method_object, method_name = false
    method_name = method_object.class.name.to_s.underscore unless method_name

    singleton_class.class_eval do; attr_accessor method_name; end
    send("#{method_name}=", method_object)
  end

  def submit params=[], *options
    @options.merge! options.extract_options!
    @params  = params

    raise "No current_user passed into form options" unless current_user.present?

    run_hook :before_submit
    # Set all the values
    set_params @params

    # Check if everything in the store is valid
    is_valid = true

    run_hook :before_validation

    store.each do |store_name, store_data|
      if (store_name != :attr_accessor and !store_data.key?(:validate)) or store_data[:validate].to_s.to_boolean != false
        is_valid &= send(store_name).valid?
      end
    end

    # Check to see if the root form is valid
    is_valid &= valid?

    # Call save command
    if is_valid
      save!
    end
  end

  def save!
    model_name_sym = self.class.model_name.to_s.underscore.to_sym
    run_hook :before_forms_save
    # Save the forms
    store.each do |store_key, current_store|
      if store_key != model_name_sym && current_store[:type] == :form and (!current_store[:validate] or current_store[:validate].to_s.to_boolean != false)
        send(store_key).save!
      end
    end
    model = send(model_name_sym)

    has_model_id = model.id

    run_hook :before_create unless has_model_id
    run_hook :before_save
    # Maybe we should move it out of options and make it a
    # mandatory field we have to pass in when calling #new
    if model.id and model.changed?
      model.set_unrestricted_attributes updater: current_user
    elsif model.id.blank?
      model.set_unrestricted_attributes creator: current_user, updater: current_user
    end
    model.save!

    if model.id
      run_hook :after_create unless has_model_id
      run_hook :after_save
    end
  end

  def set_params params, params_key = false
    # Set the current store if we have the params key
    current_store = store[params_key.to_sym] if params_key
    if  (!current_store and !params_key) or (current_store and current_store[:type] == :model)
      params.each do |key, value|
        key = key.to_sym unless key.kind_of? Symbol

        if value.kind_of? Hash
          set_params value, key
        else
          if current_store
            # Only save fields we have listed
            if current_store[:fields].include? key
              # Grab the model
              current_model = send(params_key)

              # Use our own override method
              if self.respond_to? "#{key}=" and key.to_s != 'model'
                send("#{key}=", params[key])
              else
                current_model.send("#{key}=", params[key])
              end
            elsif respond_to? "#{key}="
              send("#{key}=", value)
            end
          else
            if respond_to? "#{key}="
              send("#{key}=", value)
            end
          end
        end
      end
    elsif current_store && current_store[:type] == :form
      # This is if we are adding _form methods
      # current_form = send(current_store[:form_name])
      current_form = send(params_key)
      class_name = current_form.class.model_name.to_s.underscore.to_sym
      current_form.set_params params, class_name
      # model.send("build_#{params_key}") unless model.send(params_key).present?
      # model.send("#{params_key}=", current_form.send(class_name))
    else
      if respond_to? "#{params_key}="
        send("#{params_key}=", params)
      end
    end
  end

  class << self
    attr_accessor :store, :current_user

    def store
      @store ||= {}
    end

    def input_as name, &block
      names = name.to_s.split '.'
      if names.count < 2
        self.model_name.to_s.underscore.to_sym
        inputs_as = (store[self.model_name.to_s.underscore.to_sym][:inputs_as] ||= {})
        inputs_as[name.to_sym] = block
      else
        form_name = names.first.to_sym
        field     = names.last.to_sym
        inputs_as = (store[form_name][:inputs_as] ||= {})
        inputs_as[field] = block
      end
    end

    def delegate *fields
      options = fields.extract_options!
      # Handle the model passed
      if options.key? :to_model
        # Grab the model sym
        model_sym   = options.delete(:to_model)
        # Set the class name
        model_class = model_sym.to_s.classify
        # Set the model
        model = Object::const_get(model_class)
        # Add the option for the default rails delegate method
        options[:to] = model_sym
        # Call the default delegate method
        super(*fields, options)
        # initiate the defaults
        store[model_sym] ||= {
          type: :model,
          class: model_class,
          fields: []
        }
        # Add the fields
        store[model_sym][:fields].concat(fields).uniq!

        inherit_validation model_sym
        inherit_presence_validators model, fields
      elsif options.key? :to_form
        # Grab the form sym
        form_sym = options.delete(:to_form)
        # Model name
        form_model_name_sym = fields.first
        # Set form class name
        form_class = form_sym.to_s.classify
        # Set form object
        # Call the default delegate method
        if options[:as] == :model
          form_class.constantize.store.each do |current_key, current_store|
            if current_store[:type] == :model
              delegate(*current_store[:fields], { to_model: current_key })
            end
          end
        end
        # form = Object::const_get(form_class).new current_user
        # initiate the defaults
        store[form_model_name_sym] ||= {
          type: :form,
          class: form_class,
          form_name: form_sym
          # model_name: form.class.model_name.to_s.underscore.to_sym
        }
      elsif options.key? :to
        type = options[:to]
        if type == :attr_accessor
          fields.each do |field|
            attr_accessor field
          end
          store[type] ||= {
            type: :attr_accessor,
            fields: []
          }
          store[type][:fields].concat(fields).uniq!
        else
          super(*fields, options)
        end
      else
        super(*fields, options)
      end
    end

    def inherit_validation model_sym
      validate do
        # Validate the model
        model = send(model_sym)
        unless model.valid?
          model.errors.messages.each do |field, model_errors|
            model_errors.each do |model_error|
              errors.add field, model_error
            end
          end
        end

        # Make sure all nested forms are valid and add the errors
        store.each do |store_key, current_store|
          if store_key != :attr_accessor and (!current_store[:validate] or current_store[:validate].to_s.to_boolean != false)
            model = send(store_key)
            unless model.valid?
              model.errors.messages.each do |field, model_errors|
                model_errors.each do |model_error|
                  errors.add field, model_error
                end
              end
            end
          end
        end
      end
    end

    def inherit_presence_validators model, fields
      fields.each do |field|
        if defined? model._validators
          model._validators[field.to_sym].each do |validation|
            case validation.class.name
            when 'ActiveRecord::Validations::PresenceValidator'
              if field != :email and model.name != 'User'
                validates_presence_of field, validation.options
              else
                validates_presence_of field
              end
            end
          end
        end
      end
    end

    def form_name name
      @default_model_name = name
      # So simple form doesn't use the class name for the attribute name
      define_singleton_method 'model_name' do
        ActiveModel::Name.new(self, nil, name.to_s.classify)
      end

      # So simple form can tell if a model is associated
      define_singleton_method 'reflect_on_association' do |field|
        Object::const_get(name.to_s.classify).reflect_on_association field
      end

      # So simple form can automatically set the column type i.e. Boolean
      define_method 'column_for_attribute' do |field|
        if respond_to? "#{field}_input"
          send("#{field}_input")
        else
          send(name).column_for_attribute field
        end
      end
    end
  end
end
