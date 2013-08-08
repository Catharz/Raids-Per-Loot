require 'spec_helper'

describe 'Comments' do
  describe 'GET /comments' do
    it 'responds with success' do
      get comments_path

      response.status.should be(200)
    end

    it 'assigns the comments to @comments' do
      player = FactoryGirl.create(:player)
      comment = FactoryGirl.create(:comment, commented: player)

      get comments_path

      assigns(:comments).should eq [comment]
    end

    it 'displays the commented items name' do
      character = FactoryGirl.create(:character)
      FactoryGirl.create(:comment, commented: character)

      visit comments_path

      response.body.should include character.name
    end
  end
end
