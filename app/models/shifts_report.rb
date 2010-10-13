class ShiftsReport

  def initialize(assignments, shifts, shift_tags, people_by_group)
    @assignments = assignments
    @shifts = shifts
    @shift_tags = shift_tags
    @people_by_group = people_by_group
    @shift_person_durations = {}
    @shift_group_durations = {}
    @shift_tag_person_durations = {}
    @shift_tag_group_durations = {}
    preprocess
  end

  def shifts
    @shifts
  end

  def each_shift
    @shifts.each do |shift|
      yield shift
    end
  end

  def each_shift_tag
    @shift_tags.each do |shift_tag|
      yield shift_tag
    end
  end

  def each_group
    @people_by_group.each do |group_name, people|
      if people.size > 0
        yield group_name, people
      end
    end
  end

  def shift_group_total(shift_or_id, group_name)
    shift_id = shift_or_id.is_a?(Shift) ? shift_or_id.id : shift_or_id
    @shift_group_durations[[shift_id, group_name]]
  end

  def shift_person_total(shift_or_id, physician_or_id)
    shift_id = shift_or_id.is_a?(Shift) ? shift_or_id.id : shift_or_id
    physician_id = physician_or_id.is_a?(Physician) ? physician_or_id.id : physician_or_id
    @shift_person_durations[[shift_id, physician_id]]
  end

  def shift_tag_group_total(tag_or_id, group_name)
    tag_id = tag_or_id.is_a?(ShiftTag) ? tag_or_id.id : tag_or_id
    @shift_tag_group_durations[[tag_id, group_name]]
  end

  def shift_tag_person_total(tag_or_id, person_or_id)
    tag_id = tag_or_id.is_a?(ShiftTag) ? tag_or_id.id : tag_or_id
    person_id = person_or_id.is_a?(Physician) ? person_or_id.id : person_or_id
    @shift_tag_person_durations[[tag_id, person_id]]
  end

  private

  def preprocess
    @assignments.group_by { |a| [a.shift_id, a.physician_id] }.each do |key, assts|
      shift_id, physician_id = key[0], key[1]
      duration = assts.map(&:fixed_duration).sum
      @shift_person_durations[key] = duration == 0 ? nil : duration
      process_shifts_by_group(physician_id, shift_id, duration)
      process_shift_tags(physician_id, shift_id, duration)
    end
  end

  def process_shifts_by_group(physician_id, shift_id, duration)
    @people_by_group.each do |group_name, people|
      people_ids = people.map(&:id)
      if people_ids.include?(physician_id)
        @shift_group_durations[[shift_id, group_name]] ||= nil
        sum = @shift_group_durations[[shift_id, group_name]].to_f
        sum += duration.to_f
        @shift_group_durations[[shift_id, group_name]] = sum == 0 ? nil : sum
      end
    end
  end

  def process_shift_tags(physician_id, shift_id, duration)
    @shift_tags.each do |shift_tag|
      if shift_tag.shift_ids.include?(shift_id)
        @shift_tag_person_durations[[shift_tag.id, physician_id]] ||= nil
        sum = @shift_tag_person_durations[[shift_tag.id, physician_id]].to_f
        sum += duration.to_f
        @shift_tag_person_durations[[shift_tag.id, physician_id]] = sum == 0 ? nil : sum
        process_shift_tags_by_group(physician_id, shift_tag.id, duration)
      end
    end
  end

  def process_shift_tags_by_group(physician_id, shift_tag_id, duration)
    @people_by_group.each do |group_name, people|
      people_ids = people.map(&:id)
      if people_ids.include?(physician_id)
        @shift_tag_group_durations[[shift_tag_id, group_name]] ||= nil
        sum = @shift_tag_group_durations[[shift_tag_id, group_name]].to_f
        sum += duration.to_f
        @shift_tag_group_durations[[shift_tag_id, group_name]] = sum == 0 ? nil : sum
      end
    end
  end
end
