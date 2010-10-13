module TablesHelper

  def format_header(item, *options)
    show_markup = options.include?(:no_markup) ? false : true
    case item.class.to_s
    when "Date"
      short_date(item)
    when "Shift"
      if show_markup
        color = item.shift_tags.map(&:display_color).compact.last
        color = "#" + color if color
        [
          (image_tag('phone.jpg', :title => item.phone) if item.phone),
         "<span style=\"color:#{color};\">#{item.title}</span>"
        ].compact.join("")
      else
        item.title
      end
    when "RadDirectory::Person"
      if show_markup
        link_to item.short_name, schedule_physician_path(item)
      else
        item.short_name
      end
    when "Rotation"
      item.title
    else
      item.to_s if item.respond_to?(:to_s)
    end
  end
end
