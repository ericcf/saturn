module TablesHelper

  def format_header(item, *options)
    case item.class.to_s
    when "Date"
      item.to_s(:short_with_weekday)
    when "Shift"
      item.title
    when "RadDirectory::Person"
      item.short_name
    when "Rotation"
      item.title
    else
      item.to_s if item.respond_to?(:to_s)
    end
  end
end
