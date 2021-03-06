# == Schema Information
# Schema version: 1
#
# Table name: genome_positions
#
#  precursor_id :integer         default(0), not null
#  xsome        :string(20)
#  contig_start :integer(8)
#  contig_end   :integer(8)
#  strand       :string(2)
#  id           :integer         not null, primary key
#

class GenomePosition < ActiveRecord::Base
  
    belongs_to :precursor
  
end
