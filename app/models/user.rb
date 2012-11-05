class User < ActiveRecord::Base

  attr_accessor :password
  attr_accessible :login, :familyname, :firstname, :email, :password, :salt, :salted_password, :activated

  has_and_belongs_to_many :sources, :join_table => "user_source"
  belongs_to :country

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence   => true,
                     :format     => { :with => email_regex },
                     :uniqueness => { :case_sensitive => false }

  validates :login, :presence   => true,
            :uniqueness => { :case_sensitive => false }


  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
            :confirmation => true,
            :length       => { :within => 6..20 }

  before_save :encrypt_password

  def fullname
    return sprintf("%s, %s",familyname,firstname)
  end

  def has_password?(submitted_password)
    salted_password == encrypt(submitted_password)
  end

  def self.authenticate(login, submitted_password)
    user = find_by_login(login)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end  
  private

  def encrypt_password
#      self.salt = make_salt unless has_password?(password)
#      self.salted_password = encrypt(password)
    if (!self.activated or has_password?(password))
        self.salt = make_salt
    end
    # encrypted_password attribute mustn't be updated on account activation because 
    # no new password is being provided by the user. If it was, 
    if !self.activated_changed?
      self.salted_password = encrypt(password)
    end
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end
