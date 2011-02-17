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
      "\"rules_conflicts\":",
        "[",
        [
          duration_rule_json,
          count_rules_json
        ].compact.join(","),
        "]",
    ].join("") if !duration_rule.nil? || !count_rules.blank?
  end

  def duration_rule_json
    weekly_conflicts && duration_rule.to_json
  end

  def count_rules_json
    json = count_rules.map do |rule|
      rule.to_json(assignments_by_physician_id)
    end.compact.join(",")
    json == "" ? nil : json
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

  def physician_ids_over_daily_count_max(rule)
    rule.process(assignments_by_physician_id)
  end

  def weekly_conflicts
    return @weekly_conflicts if @weekly_conflicts
    @weekly_conflicts = duration_rule && duration_rule.process(assignments_by_physician_id)
  end
end
