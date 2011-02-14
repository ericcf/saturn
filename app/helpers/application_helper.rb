module ApplicationHelper

  include TablesHelper

  def nav_item(title, path, html_options={}, action=nil, klass=nil, path_match=nil)
    return if action && klass && cannot?(action, klass)
    li_class = [(path_match?(path_match || path) ? "active" : ""), html_options[:class]]
    "<li class=\"#{li_class.compact.join(" ")}\">" +
    link_to(title, path, :class => path_match?(path_match || path) ? "current" : "") +
    "</li>"
  end

  def short_date(date, options=[])
    [
       options.include?(:without_day) ? nil : date.strftime("%a"),
      "#{date.month}/#{date.day}"
    ].compact.join(" ")
  end

  def page_title(text)
    content_for(:page_title) { text }
  end

  private

  # helps determine current tab
  def path_match?(path)
    if path.is_a?(Regexp)
      return !(request.path =~ path).nil?
    end
    if path == "/"
      return request.path == "/"
    end
    !(request.path =~ /^#{path}/).nil?
  end
end
