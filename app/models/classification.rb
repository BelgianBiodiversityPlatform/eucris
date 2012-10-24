class Classification < ActiveRecord::Base
  belongs_to :classscheme
  belongs_to :parent, :class_name =>"Classification", :foreign_key => "parent_id"
  has_and_belongs_to_many :fundings, :join_table => "funding_class"
  has_and_belongs_to_many :projects, :join_table => "project_class"
  has_and_belongs_to_many :orgunits, :join_table => "orgunit_class"
  has_and_belongs_to_many :people, :join_table => "person_class"
end
