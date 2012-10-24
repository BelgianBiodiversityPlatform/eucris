class Publication < ActiveRecord::Base
  belongs_to :source
  belongs_to :classification
end
