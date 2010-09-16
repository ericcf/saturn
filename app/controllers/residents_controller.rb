class ResidentsController < ApplicationController

  def rotations
    group = Group.find_by_title("Residents")
    @residents = Membership.find_all_by_group_id(group.id).map(&:person).
      compact.sort_by(&:family_name)
    blocks = (Date.new(2010, 6, 21)..Date.new(2011, 5, 21)).step(28).to_a
    @block_weeks = blocks.map do |block_start|
      (block_start..block_start+21).step(7).to_a
    end
    assignments = RotationAssignment.find_all_by_person_id_and_starts_on(@residents.map(&:id), @block_weeks.flatten, :include => :rotation)
    @assignment_by_person_and_date = assignments.each_with_object({}) do |a, hsh|
      hsh[[a.person_id, a.starts_on]] = a
    end
  end
end
