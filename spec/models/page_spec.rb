require 'spec_helper'

describe Page do
  describe '#parent_navlabel' do
    it 'should return the navlabel when it has a parent' do
      parent = FactoryGirl.create(:page, name: 'Parent', title: 'Parent', navlabel: 'Parent', body: '.')
      child = FactoryGirl.create(:page, name: 'Child', title: 'Child', navlabel: 'Child', body: '.', parent_id: parent.id)

      child.parent_navlabel.should eq 'Parent'
    end
  end

  describe '#is_admin?' do
    it 'should return Yes when it is an admin page' do
      page = FactoryGirl.create(:page, name: 'Admin', admin: true)

      page.is_admin?.should eq 'Yes'
    end

    it 'should return No when it is not an admin page' do
      page = FactoryGirl.create(:page, name: 'Non-Admin', admin: false)

      page.is_admin?.should eq 'No'
    end
  end

  describe '#redirection' do
    it 'should return controller/action when redirected' do
      page = FactoryGirl.create(:page, redirect: true, controller_name: 'page', action_name: 'show')

      page.redirection.should eq 'page/show'
    end

    it 'should return None when not redirected' do
      page = FactoryGirl.create(:page)

      page.redirection.should eq 'None'
    end
  end
end