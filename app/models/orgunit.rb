class Orgunit < ActiveRecord::Base
  belongs_to :source
  belongs_to :classification
  belongs_to :top, :class_name => "Orgunit"

  scope :agencies, where(:isfunding => true)
  scope :research, where(:isfunding => false)
  scope :aroots, where(:isfunding => true, :parent_id => nil) 
  scope :rroots, where(:isfunding => false, :parent_id => nil) 

  has_and_belongs_to_many :classifications, :join_table => "orgunit_class", :order => "id" 
  has_and_belongs_to_many :fundings, :join_table => "orgunit_funding"
  has_and_belongs_to_many :projects, :join_table => "project_orgunit"
  has_and_belongs_to_many :people, :join_table => "person_orgunit"
  has_and_belongs_to_many :orgunits, :join_table => "orgunit_orgunit", :foreign_key => "orgunit1_id", :association_foreign_key => "orgunit2_id"
end
