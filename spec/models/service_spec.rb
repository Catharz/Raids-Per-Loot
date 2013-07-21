require 'spec_helper'

describe Service do
  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }
    it { should validate_presence_of(:uname) }
    it { should validate_presence_of(:uemail) }
  end
end
