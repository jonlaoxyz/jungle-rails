require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'should be created with password and password_confirmation fields' do
      user = User.new(
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user.save).to be true
    end

    it 'should have matching password and password_confirmation' do
      user = User.new(
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'different_password'
      )
      expect(user.save).to be false
      expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'should require password and password_confirmation on create' do
      user = User.new(email: 'test@example.com')
      expect(user.save).to be false
      expect(user.errors.full_messages).to include("Password can't be blank")
    end

    it 'should have a unique email (case-insensitive)' do
      existing_user = User.create(email: 'test@example.com', password: 'password')
      user = User.new(email: 'TEST@example.com', password: 'different_password')
      expect(user.save).to be false
      expect(user.errors.full_messages).to include("Email has already been taken")
    end

    it 'should require email, first name, and last name' do
      user = User.new(password: 'password', password_confirmation: 'password')
      expect(user.save).to be false
      expect(user.errors.full_messages).to include("Email can't be blank", "First name can't be blank", "Last name can't be blank")
    end
  end

  describe '.authenticate_with_credentials' do
    it 'should authenticate with valid credentials' do
      user = User.create(email: 'test@example.com', password: 'password')
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'password')
      expect(authenticated_user).to eq(user)
    end

    it 'should return nil with invalid email' do
      authenticated_user = User.authenticate_with_credentials('invalid@example.com', 'password')
      expect(authenticated_user).to be_nil
    end

    it 'should return nil with invalid password' do
      user = User.create(email: 'test@example.com', password: 'password')
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'invalid_password')
      expect(authenticated_user).to be_nil
    end

    it 'should authenticate with email containing spaces' do
      user = User.create(email: 'test@example.com', password: 'password')
      authenticated_user = User.authenticate_with_credentials(' test@example.com ', 'password')
      expect(authenticated_user).to eq(user)
    end

    it 'should authenticate with email in different case' do
      user = User.create(email: 'test@example.com', password: 'password')
      authenticated_user = User.authenticate_with_credentials('TEST@example.COM', 'password')
      expect(authenticated_user).to eq(user)
    end
  end
end