require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:user_friendships)
  should have_many(:friends)

  test "a user should enter a first name"  do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name"  do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end

  test "a user should enter a profile name"  do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a unique profile name" do
  	user = User.new
  	user.profile_name = users(:temple).profile_name
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
  	user = User.new
  	user.profile_name = "My Profile With Spaces"
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	assert user.errors[:profile_name].include?("Must be formatted correctly.")
  end

  test "a user should be able to register with a valid profile name" do
  	user = User.new(first_name: "Temple", last_name: "Jones", email: "tj2@jones.com")
  	user.password = user.password_confirmation = 'asdfasf'
  	user.profile_name = 't_jones'
  	assert user.save
  	assert user.valid?
  end

  test "that no error is raised when trying to access a friend list" do
  	assert_nothing_raised do
  		users(:temple).friends
  	end
  end

  test "that creating friendships on a user works" do
  	users(:temple).friends << users(:crack)
  	users(:temple).friends.reload

  	assert users(:temple).friends.include?(users(:crack))
  end

  test "that creatigna friendship based on user id and friend id works" do
  	UserFriendship.create user_id: users(:temple).id, friend_id: users(:crack).id
  	assert users(:temple).friends.include?(users(:crack))
  end
end
