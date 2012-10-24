class Project < ActiveRecord::Base
  belongs_to :source
  belongs_to :classification
  has_and_belongs_to_many :classifications, :join_table => "project_class", :order => "id" 
  has_and_belongs_to_many :fundings, :join_table => "project_funding"
  has_and_belongs_to_many :people, :join_table => "project_person"
  has_and_belongs_to_many :orgunits, :join_table => "project_orgunit"
  has_and_belongs_to_many :projects, :join_table => "project_project", :foreign_key => "project1_id", :association_foreign_key => "project2_id"
  has_and_belongs_to_many :publications, :join_table => "project_publication"
end
