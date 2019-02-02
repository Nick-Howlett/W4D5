require 'rails_helper'
require 'shoulda-matchers'

RSpec.describe User, type: :model do
  subject(:user){User.create(username: "test", password: "password")}
  it {should validate_presence_of(:username)}
  it {should validate_presence_of(:password_digest)}
  it {should validate_presence_of(:session_token)}
  it {should validate_uniqueness_of(:username)}
  it {should validate_uniqueness_of(:session_token)}
  it {should validate_length_of(:password).is_at_least(6)}
  
  describe "#ensure_session_token" do 
    it "makes sure that session_token exists" do
      expect(user.session_token).not_to be_nil
    end
  end

  describe "is_password?" do
    context "If true" do
      it "should return true if password_digest matches" do
        expect(user.is_password?(user.password)).to be true
      end
    end
    context "if false" do
      it "should return false if password_digest doesnt match" do 
        expect(user.is_password?("")).to be false
      end
    end
  end

  describe "find_by_credentials" do
    context "if user exists" do
      it "finds a user" do
        expect(User.find_by_credentials(user.username, user.password)).to eq(user)
      end
    end
    context "if user doesn't exist" do
      it "does not find a user" do
        expect(User.find_by_credentials("", "")).to be nil
      end
    end
  end
  
  describe "reset_session_token" do
    it "resets the session token" do 
      token = user.session_token
      user.reset_session_token!
      expect(user.session_token).not_to eq(token)

    end

    it "returns the new session token" do 
      expect(user.reset_session_token!).to eq(user.session_token)
    end
  end
  

  describe "password=" do 
    it "does not save the password to the database" do
      expect(user.password_digest).not_to eq(user.password)
    end

    it "calls the BCrypt method" do
      expect(BCrypt::Password).to receive(:create).with(user.password)
      user.password = user.password
    end
  end
end
