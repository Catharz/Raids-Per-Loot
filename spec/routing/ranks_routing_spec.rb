require "spec_helper"

describe RanksController do
  describe "routing" do

    it "routes to #index" do
      get("/ranks").should route_to("ranks#index")
    end

    it "routes to #new" do
      get("/ranks/new").should route_to("ranks#new")
    end

    it "routes to #show" do
      get("/ranks/1").should route_to("ranks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/ranks/1/edit").should route_to("ranks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/ranks").should route_to("ranks#create")
    end

    it "routes to #update" do
      put("/ranks/1").should route_to("ranks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/ranks/1").should route_to("ranks#destroy", :id => "1")
    end

  end
end
