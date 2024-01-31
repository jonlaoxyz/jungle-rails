class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  def self.authenticate_with_credentials(email, password)
    # Find the user by email (case-insensitive)
    user = User.where('LOWER(email) = ?', email.downcase.strip).first

    # Check if the user exists and the password is correct
    if user && user.authenticate(password)
      return user # Return the authenticated user
    else
      return nil # Return nil if authentication fails
    end
  end
  
end
