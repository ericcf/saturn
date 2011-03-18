module ApplicationHelper

  include TablesHelper

  def nav_item(title, path, html_options={}, action=nil, klass=nil, path_match=nil)
    return if action && klass && cannot?(action, klass)
    li_class = [(path_match?(path_match || path) ? "active" : ""), html_options[:class]]
    "<li class=\"#{li_class.compact.join(" ")}\">" +
    link_to(title, path, :class => path_match?(path_match || path) ? "current" : "") +
    "</li>"
  end

  def page_title(text)
    content_for(:page_title) { text }
  end

  def holiday_title_on(date)
    @holidays_by_date ||= Holiday.all.group_by(&:date)
    (@holidays_by_date[date] || [Holiday.new]).first.title
  end

  # returns a string of days with single digits padded with an extra space
  # e.g. [2011-1-8, 2011-1-9, 2011-10] => "&nbsp;8 &nbsp;9 10"
  def print_padded_days(dates)
    @today ||= Date.today
    dates.map do |date|
      date_str = "#{date.day < 10 ? "&nbsp;" : ""}#{date.day}"
      date_str = date == @today ? "<span class=\"current-date\">#{date_str}</span>" : date_str
    end.join(" ")
  end

  def print_padded_day_letters
    letters = Date::ABBR_DAYNAMES.map(&:first)
    (1..7).map { |i| "&nbsp;#{letters[i % 7]}" }.join(" ")
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
