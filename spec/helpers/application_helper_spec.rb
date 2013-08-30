require 'spec_helper'
include ApplicationHelper

describe ApplicationHelper do
  before(:each) do
    @p1 = FactoryGirl.create(:page, position: 0)
    @p1a = FactoryGirl.create(:page, parent: @p1, position: 0)
    @p1b = FactoryGirl.create(:page, parent: @p1, position: 1)

    @p2 = FactoryGirl.create(:page, position: 1, admin: true)
    @p2a = FactoryGirl.create(:page, parent: @p2, position: 0, admin: true)
    @p2b = FactoryGirl.create(:page, parent: @p2, position: 1, admin: true)
  end

  describe 'menu' do
    it 'returns an unordered list' do
      expected = "<ul><li>#{@p1.to_url}<ul><li>#{@p1a.to_url}</li>" +
          "<li>#{@p1b.to_url}</li></ul></li>"
      expected << "<li>#{@p2.to_url}<ul><li>#{@p2a.to_url}</li>" +
          "<li>#{@p2b.to_url}</li></ul></li></ul>"

      menu.should eq expected
    end
  end
end
