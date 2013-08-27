require 'spec_helper'

describe Link do
  context "associations" do
    it { should have_many(:link_categories_links) }
    it { should have_many(:link_categories) }
  end

  context "validations" do
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
end