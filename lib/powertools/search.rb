class Search < OpenStruct
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  def initialize(columns, params = {})
    @columns, @params = columns, params
    @sort_column      = @params[:sort_column] || false
    @sort_direction   = @params[:sort_direction] || false
    super params
  end

  def sort_column
    @sort_column
  end

  def sort_direction
    @sort_direction
  end

  def remove_search_keys key
    cleaned_key = key.to_s.gsub(/(_like|_notin|_in|_greater|_range)/, '')
    :"#{cleaned_key}"
  end

  def to_s
    params = @params.select do |key, value|
      @columns.grep(remove_search_keys(key)).length != 0 and value.to_s.length != 0
    end
    search = []
    params.each do |key, value|
      if value
        key = key.to_s
        case key
        when /_like$/
          search.push "#{key.gsub(/_like$/, '')} ~ \"#{value}\""
        when /_in$/
          search.push "#{key.gsub(/_in$/, '')} ^ \"#{value}\""
        when /_notin$/
          search.push "#{key.gsub(/_notin$/, '')} !^ \"#{value}\""
        when /_greater$/
          search.push "#{key.gsub(/_greater$/, '')} >= \"#{value}\""
        when /_range$/
          new_key = key.gsub(/_range$/, '')
          greater_than, less_than = value.split('-')
          if greater_than
            greater_than = Chronic.parse(greater_than).strftime('%Y-%m-%d 00:00:00')
            search.push "#{new_key} >= \"#{greater_than}\""
          end
          if less_than
            less_than    = Chronic.parse(less_than).strftime('%Y-%m-%d 24:00:00')
            search.push "#{new_key} < \"#{less_than}\""
          end
        else
          search.push "#{key} = \"#{value}\""
        end
      end
    end
    search.join ' AND '
  end

  # ActiveModel needs to know that this wasn't persisted.
  # def persisted? ; false ; end;
end

