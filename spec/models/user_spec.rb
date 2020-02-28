require 'rails_helper'

RSpec.describe User do
  it 'assigns the current subdomain on create' do
    # test the before create callback by creating a user and testing the subdomain value
  end

  it 'adds super admin role if the super admin attribute is set' do
    # test the after save callback
  end
end
