module ApplicationHelper

  def nav_item(title, path)
    "<li class=\"#{current_page?(path) ? "active" : ""}\">" +
    link_to(title, path, :class => current_page?(path) ? "current" : "") +
    "</li>"
  end
end
