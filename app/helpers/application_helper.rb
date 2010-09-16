module ApplicationHelper

  def nav_item(title, path, html_options={}, action=nil, klass=nil)
    return if action && klass && cannot?(action, klass)
    li_class = [(current_page?(path) ? "active" : ""), html_options[:class]]
    "<li class=\"#{li_class.compact.join(" ")}\">" +
    link_to(title, path, :class => current_page?(path) ? "current" : "") +
    "</li>"
  end
end
