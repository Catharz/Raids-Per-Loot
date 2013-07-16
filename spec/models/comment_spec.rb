require 'spec_helper'

describe Comment do
  context 'validations' do
    it { should validate_presence_of(:comment_date) }
    it { should validate_presence_of(:commented_type) }
    it { should validate_presence_of(:commented) }
    it { should validate_presence_of(:comment) }
  end

  context 'scopes' do
    describe '#by_player' do
      it 'returns all by default' do
        comments = []
        3.times do |n|
          comments << FactoryGirl.create(:comment, comment: "Comment #{n}")
        end

        Comment.by_player.should match_array comments
      end

      it 'filters by player' do
        player = FactoryGirl.create(:player)
        2.times do |n|
          FactoryGirl.create(:comment, comment: "Comment #{n}")
        end
        comment = FactoryGirl.create(:comment, commented: player)

        Comment.by_player(player.id).should eq [comment]
      end
    end
  end
end
