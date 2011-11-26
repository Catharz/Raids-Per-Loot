require "spec_helper"

describe ZonesController do
  describe "routing" do

    it "routes to #index" do
      get("/zones").should route_to("zones#index")
    end

    it "routes to #new" do
      get("/zones/new").should route_to("zones#new")
    end

    it "routes to #show" do
      get("/zones/1").should route_to("zones#show", :id => "1")
    end

    it "routes to #edit" do
      get("/zones/1/edit").should route_to("zones#edit", :id => "1")
    end

    it "routes to #create" do
      post("/zones").should route_to("zones#create")
    end

    it "routes to #update" do
      put("/zones/1").should route_to("zones#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/zones/1").should route_to("zones#destroy", :id => "1")
    end

  end
end
