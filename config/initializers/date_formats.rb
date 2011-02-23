Date::DATE_FORMATS[:short_with_weekday] = lambda do |date|
  date.strftime("%a #{date.month}/#{date.day}")
end
Date::DATE_FORMATS[:short] = lambda { |date| "#{date.month}/#{date.day}" }
