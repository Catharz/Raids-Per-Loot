require 'spec_helper'
include InstancesHelper

describe InstancesHelper do
  describe '#mob_names' do
    it 'lists the mob names' do
      mob = FactoryGirl.create(:mob, name: 'Jar-jar')
      instance = FactoryGirl.create(:instance)
      instance.should_receive(:kills).and_return([mob])

      mob_names(instance).should eq 'Jar-jar'
    end

    it "lists the mob alias'" do
      mob = FactoryGirl.create(:mob, name: 'Jabba', alias: 'Fattso')
      instance = FactoryGirl.create(:instance)
      instance.should_receive(:kills).and_return([mob])

      mob_names(instance).should eq 'Fattso'
    end

    it 'joins the mob names with </br>' do
      mob1 = FactoryGirl.create(:mob)
      mob2 = FactoryGirl.create(:mob)
      instance = FactoryGirl.create(:instance)
      instance.should_receive(:kills).and_return([mob1, mob2])

      mob_names(instance).should eq "#{mob1.name}</br>#{mob2.name}"
    end
  end
end
