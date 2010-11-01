module PhysiciansHelper

  # returns assigned shifts grouped by date and physician, e.g.:
  # [
  #   {
  #     :physician => #<Physician id:1, ...>,
  #     :daily_shifts => [
  #       {
  #         :date => 2010-01-01,
  #         :shifts => [
  #           #<Shift id:2, ...>,
  #           ...
  #         ]
  #       },
  #       ...
  #     ]
  #   },
  #   ...
  # ]
  #
  # if there are no shifts on a particular date, an empty list is assigned
  def physicians_weekly_schedules(physicians, dates, assignments)
    return [] if physicians.blank?
    assignments_by_physician_id = assignments.group_by { |a| a.physician_id }
    physicians.map do |physician|
      physician_assignments = assignments_by_physician_id[physician.id] || []
      assignments_by_date = physician_assignments.group_by { |a| a.date }
      daily_shifts = dates.map do |date|
        daily_assignments = assignments_by_date[date] || []
        { :date => date, :shifts => daily_assignments.map(&:shift) }
      end
      { :physician => physician, :daily_shifts => daily_shifts }
    end
  end
end
