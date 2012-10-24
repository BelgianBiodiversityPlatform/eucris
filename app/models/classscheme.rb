class Classscheme < ActiveRecord::Base
  has_many :classifications, :order => "id"
  scope :originals, where(:original => true)
end
