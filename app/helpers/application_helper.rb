module ApplicationHelper

  include TablesHelper

  def nav_item(title, path, html_options={}, action=nil, klass=nil)
    return if action && klass && cannot?(action, klass)
    li_class = [(current_page?(path) ? "active" : ""), html_options[:class]]
    "<li class=\"#{li_class.compact.join(" ")}\">" +
    link_to(title, path, :class => current_page?(path) ? "current" : "") +
    "</li>"
  end

  def short_date(date, options=[])
    [
       options.include?(:without_day) ? nil : date.strftime("%a"),
      "#{date.month}/#{date.day}"
    ].compact.join(" ")
  end
end
