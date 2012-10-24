class Contact_Message < ActiveRecord::Base
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence   => true,
                     :format     => { :with => email_regex }

  validates :body, :presence => true,
                  :length => { :maximum => 1024 }
end
