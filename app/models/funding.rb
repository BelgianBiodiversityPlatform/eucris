class Funding < ActiveRecord::Base
  belongs_to :source
  belongs_to :classification
  has_and_belongs_to_many :classifications, :join_table => "funding_class"
  has_and_belongs_to_many :projects, :join_table => "project_funding"
  has_and_belongs_to_many :people, :join_table => "person_funding"
  has_and_belongs_to_many :orgunits, :join_table => "orgunit_funding"
  has_and_belongs_to_many :fundings, :join_table => "funding_funding",  :foreign_key => "funding1_id", :association_foreign_key => "funding2_id"
  

end
