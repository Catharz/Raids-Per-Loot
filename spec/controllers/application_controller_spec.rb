require 'spec_helper'

describe ApplicationController do
  fixtures :users

  describe '#get_page_details' do
    it 'calls #get_pages' do
      controller.should_receive(:get_pages)

      controller.get_page_details
    end
  end

  describe '#get_pages' do
    context 'finds pages' do
      specify 'by name' do
        FactoryGirl.create(:page, position: 1)
        p2 = FactoryGirl.create(:page, position: 2)
        FactoryGirl.create(:page, position: 3)
        params = {name: p2.name}

        controller.get_pages(params)[0].should eq(p2)
      end

      specify 'by name using the controller name if the action is index' do
        p1 = FactoryGirl.create(:page, position: 1, name: 'funky')
        FactoryGirl.create(:page, position: 2)
        FactoryGirl.create(:page, position: 3)
        params = {controller: 'funky', action: 'index'}

        controller.get_pages(params)[0].should eq(p1)
      end

      specify 'by action and controller names' do
        FactoryGirl.create(:page, position: 1)
        FactoryGirl.create(:page, position: 2)
        p3 = FactoryGirl.create(:page, position: 3, controller_name: 'one', action_name: 'two')
        params = {controller: 'one', action: 'two'}

        controller.get_pages(params)[0].should eq(p3)
      end
    end

    it 'returns the page title' do
      p1 = FactoryGirl.create(:page, position: 1)
      FactoryGirl.create(:page, position: 2)
      FactoryGirl.create(:page, position: 3)
      params = {name: p1.name}

      controller.get_pages(params)[1].should eq(p1.title)
    end

    it 'returns the child pages' do
      parent = FactoryGirl.create(:page)
      p1 = FactoryGirl.create(:page, position: 1, parent_id: parent.id)
      p2 = FactoryGirl.create(:page, position: 2, parent_id: parent.id)
      p3 = FactoryGirl.create(:page, position: 3, parent_id: parent.id)
      params = {name: parent.name}

      controller.get_pages(params)[2].should eq([p1, p2, p3])
    end
  end

  describe '#get_tabs' do
    it 'assigns a list of pages sorted by position to @tabs' do
      p1 = FactoryGirl.create(:page, position: 1)
      p2 = FactoryGirl.create(:page, position: 2)
      p3 = FactoryGirl.create(:page, position: 3)

      controller.get_tabs

      assigns(:tabs).should eq([p1, p2, p3])
    end

    it 'filters out admin pages when not logged in' do
      p1 = FactoryGirl.create(:page, position: 1)
      p2 = FactoryGirl.create(:page, position: 2)
      FactoryGirl.create(:page, position: 3, admin: true)

      controller.get_tabs

      assigns(:tabs).should eq([p1, p2])
    end

    it 'includes admin pages when logged in' do
      p1 = FactoryGirl.create(:page, position: 1)
      p2 = FactoryGirl.create(:page, position: 2)
      p3 = FactoryGirl.create(:page, position: 3, admin: true)

      login_as :quentin
      controller.get_tabs

      assigns(:tabs).should eq([p1, p2, p3])
    end
  end

  describe '#get_root_pages' do
    it 'assigns a list of root pages to @root_pages' do
      parent = FactoryGirl.create(:page)
      1.upto(3) do
        FactoryGirl.create(:page, parent_id: parent.id)
      end

      controller.get_root_pages.should eq([parent])
    end
  end

  describe '#page_children' do
    it 'returns a list of children for the provided page' do
      parent = FactoryGirl.create(:page)
      p1 = FactoryGirl.create(:page, position: 1, parent_id: parent.id)
      p2 = FactoryGirl.create(:page, position: 2, parent_id: parent.id)
      p3 = FactoryGirl.create(:page, position: 3, parent_id: parent.id)

      controller.page_children(parent).should eq([p1, p2, p3])
    end

    it 'filters out admin pages when not logged in' do
      parent = FactoryGirl.create(:page)
      p1 = FactoryGirl.create(:page, position: 1, parent_id: parent.id)
      p2 = FactoryGirl.create(:page, position: 2, parent_id: parent.id)
      FactoryGirl.create(:page, position: 3, parent_id: parent.id, admin: true)

      controller.page_children(parent).should eq([p1, p2])
    end

    it 'includes admin pages when logged in' do
      parent = FactoryGirl.create(:page)
      p1 = FactoryGirl.create(:page, position: 1, parent_id: parent.id)
      p2 = FactoryGirl.create(:page, position: 2, parent_id: parent.id)
      p3 = FactoryGirl.create(:page, position: 3, parent_id: parent.id, admin: true)

      login_as :quentin

      controller.page_children(parent).should eq([p1, p2, p3])
    end
  end
end