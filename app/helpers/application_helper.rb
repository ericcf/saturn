module ApplicationHelper

  include TablesHelper

  def nav_item(title, path, html_options={}, action=nil, klass=nil)
    return if action && klass && cannot?(action, klass)
    li_class = [(path_match?(path) ? "active" : ""), html_options[:class]]
    "<li class=\"#{li_class.compact.join(" ")}\">" +
    link_to(title, path, :class => path_match?(path) ? "current" : "") +
    "</li>"
  end

  def short_date(date, options=[])
    [
       options.include?(:without_day) ? nil : date.strftime("%a"),
      "#{date.month}/#{date.day}"
    ].compact.join(" ")
  end

  private

  def path_match?(path)
    if path == "/"
      return request.path == "/"
    end
    !(request.path =~ /^#{path}/).nil?
  end
end
