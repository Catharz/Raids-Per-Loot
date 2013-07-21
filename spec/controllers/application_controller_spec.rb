require 'spec_helper'

describe ApplicationController do
  fixtures :users, :services

  describe '#current_user' do
    it 'sets the user id using the session' do
      controller.session[:user_id] = users(:admin).id

      controller.send(:current_user).should eq users(:admin)
    end
  end

  describe '#user_signed_in?' do
    it 'returns 1 if the current user is set' do
      controller.session[:user_id] = users(:raid_leader).id

      controller.send(:user_signed_in?).should eq 1
    end

    it 'returns nil if not logged in' do
      controller.send(:user_signed_in?).should be_nil
    end
  end
end