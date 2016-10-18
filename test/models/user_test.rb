require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "claims invitations after creation" do
    Invitation::Claim.expects(:call)
    User.create!(user_attrs)
  end

  test "does not claim invitations after update" do
    user = User.create!(user_attrs)
    Invitation::Claim.expects(:call).never
    user.first_name = "Updated"
    user.save!
  end

  test "does not claim invitations if creation fails" do
    Invitation::Claim.expects(:call).never
    user = User.create(user_attrs.merge(email: nil))
  end

  private

  def user_attrs
    password = User.new.send(:password_digest, 'somepassword')
    {
      first_name: "First",
      last_name: "Last",
      email: "some@email.com",
      password: password,
      password_confirmation: password
    }
  end
end
