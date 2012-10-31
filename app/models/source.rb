class Source < ActiveRecord::Base
  has_many :fundings, :order => 'name'
  has_many :projects, :order => 'title'
  has_many :orgunits, :order => 'isfunding desc, name'
  has_many :people, :order => 'familyName, firstName'
  belongs_to :role
  belongs_to :country
end
