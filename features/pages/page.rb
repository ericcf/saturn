class Page

  def initialize(page, options = {})
    @page = page
    @options = options
  end

  def date_to_db(date)
    Chronic.parse(date).to_s(:db)
  end
end
