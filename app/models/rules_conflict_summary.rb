class RulesConflictSummary
  extend ActiveModel::Naming

  attr_accessor :section, :weekly_schedule, :assignments

  def initialize(attributes = {})
    return unless attributes.respond_to?(:each)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def to_json
    [
      "[",
      [
        duration_rule_json,
        count_rules_json
      ].join(","),
      "]"
    ].join("")
  end

  def duration_rule_json
    [
      "{",
        "\"title\":\"Below weekly minimum (#{duration_rule.minimum})\",",
        "\"conflict_by_offender_id\":",
          physician_ids_under_weekly_duration_min.to_json,
      "},",
      "{",
        "\"title\":\"Above weekly maximum (#{duration_rule.maximum})\",",
        "\"conflict_by_offender_id\":",
          physician_ids_over_weekly_duration_max.to_json,
      "}"
    ].join("") if duration_rule
  end

  def count_rules_json
    count_rules.map do |rule|
      [
      "{",
        "\"title\":\"Above daily maximum for #{rule.shift_tag.title} (#{rule.maximum})\",",
        "\"conflict_by_offender_id\":",
          physician_ids_over_daily_count_max(rule).to_json,
      "}"
      ].join("") if rule.maximum
    end.compact.join(",")
  end

  def assignments_by_physician_id
    @assignments_by_physician_id ||= assignments.group_by { |a| a.physician_id }
  end

  def duration_rule
    @duration_rule ||= section.weekly_shift_duration_rule
  end

  def count_rules
    @count_rules ||= section.daily_shift_count_rules
  end

  def physician_ids_under_weekly_duration_min
    weekly_offenders[:below_minimum]
  end

  def physician_ids_over_weekly_duration_max
    weekly_offenders[:above_maximum]
  end

  def physician_ids_over_daily_count_max(rule)
    rule.process(assignments_by_physician_id)
  end

  private

  def weekly_offenders
    return @weekly_offenders if @weekly_offenders
    @weekly_offenders = duration_rule.process(assignments_by_physician_id)
  end
end
