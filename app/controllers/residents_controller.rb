require 'minimal_bin'
require 'tables'

class ResidentsController < ApplicationController

  def rotations
    group = Group.find_by_title("Residents")
    residents = Membership.find_all_by_group_id(group.id, :include => { :person => :names_alias }).map(&:person).compact.sort_by(&:family_name)
    blocks = (Date.new(2010, 6, 21)..Date.new(2010, 10, 10)).step(28).to_a
    @block_weeks = blocks.map do |block_start|
      (block_start..block_start+21).step(7).to_a
    end.flatten
    assignments = RotationAssignment.find_all_by_person_id_and_starts_on(residents.map(&:id), @block_weeks, :include => [:rotation, { :person => :names_alias }])
    @view_mode = (params[:view_mode] || 1).to_i
    @rotation_data = case @view_mode
                     when 1
                       Tables::MulticolumnTabularData.new(
      :x => [@block_weeks, :clone],
      :y => [residents, assignment_bins_by(:person_id, assignments, residents.map(&:id)), :id],
      :mapped_values => assignments.group_by{|a| [a.starts_on, a.person_id]},
      :content_formatter => lambda do |assignment|
        assignment.rotation.title
      end
                       )
                     when 2
                       rotations = Rotation.all
                       Tables::MulticolumnTabularData.new(
      :x => [@block_weeks, :clone],
      :y => [rotations, assignment_bins_by(:rotation_id, assignments, rotations.map(&:id)), :id],
      :mapped_values => assignments.group_by{|a| [a.starts_on, a.rotation_id]},
      :content_formatter => lambda do |assignment|
        assignment.person.short_name
      end
                       )
                     end
  end

  private

  def assignment_bins_by(attribute, assignments, order_by)
    grouped_assignments = assignments.group_by(&attribute)
    order_by.map do |index|
      if grouped_assignments[index]
        assignment_items = grouped_assignments[index].map do |assignment|
          size = ((assignment.ends_on - assignment.starts_on)/7).round
          BinItem.new size, @block_weeks.index(assignment.starts_on), assignment
        end
        MinimalBin.new(assignment_items, @block_weeks.size)
      end
    end
  end
end
