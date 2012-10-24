class Person < ActiveRecord::Base
  belongs_to :source
  belongs_to :classification
  has_and_belongs_to_many :classifications, :join_table => "person_class", :order => "id" 
  has_and_belongs_to_many :fundings, :join_table => "person_funding"
  has_and_belongs_to_many :projects, :join_table => "project_person"
  has_and_belongs_to_many :orgunits, :join_table => "person_orgunit"

def fullname
  return sprintf("%s, %s",familyname,firstname)
end

end
