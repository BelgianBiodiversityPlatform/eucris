class Country < ActiveRecord::Base
  has_many :sources

  scope :partners, where( 'socount > 0')

end
