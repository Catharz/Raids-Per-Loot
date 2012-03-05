require 'spec_helper'

describe ViewerController do

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :name => "home"
      response.should be_success
    end
  end

end
