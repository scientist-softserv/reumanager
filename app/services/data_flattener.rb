class DataFlattener
  attr_reader :data, :selected_fields
  attr_accessor :section_selected_fields

  def initialize(data, selected_fields = {})
    @data = data
    @selected_fields = selected_fields
  end

  def flatten
    data.each_with_object({}) do |(title, section), h|
      self.section_selected_fields = selected_fields[title]
      case section
      when Hash
        h.merge!(single_section_values(title, section))
      when Array
        h.merge!(repeating_section_values(title, section))
      end
    end
  end

  private

  def allow_field?(key)
    section_selected_fields[key] == '1'
  end

  def single_section_values(title, section)
    section.each_with_object({}) do |(k, v), h|
      next unless allow_field?(k)

      h[k] = { value: v, path: "#{title}--#{k}" }
    end
  end

  def repeating_section_values(title, section)
    section.each_with_object({}).with_index do |(sub_section, hash), index|
      values = sub_section.each_with_object({}) do |(k, v), h|
        next unless allow_field?(k)

        h["#{k}_#{index + 1}"] = { value: v, path: "#{title}--#{index}--#{k}" }
      end
      hash.merge!(values)
    end
  end
end
