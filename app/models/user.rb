class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  # Add any other validations you need for first_name, last_name, etc.
end
