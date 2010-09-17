module ApplicationHelper

  def nav_item(title, path, html_options={}, action=nil, klass=nil)
    return if action && klass && cannot?(action, klass)
    li_class = [(current_page?(path) ? "active" : ""), html_options[:class]]
    "<li class=\"#{li_class.compact.join(" ")}\">" +
    link_to(title, path, :class => current_page?(path) ? "current" : "") +
    "</li>"
  end

  def save_or_cancel(form, cancel_path)
    save_button = form.nil? ? submit_tag("Save", :class => "button") : form.submit("Save", :class => "button")
    "#{save_button} or #{link_to "Cancel", cancel_path}".html_safe
  end
end
