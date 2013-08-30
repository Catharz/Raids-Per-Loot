require 'spec_helper'

describe Page do

  describe '#to_url' do
    it 'uses the name by default' do
      page = FactoryGirl.create(:page, name: 'somewhere')

      page.to_url.should eq "<a href='/somewhere'>#{page.navlabel}</a>"
    end

    it 'handles redirects' do
      page = FactoryGirl.create(:page, redirect: true,
                                controller_name: 'wilma',
                                action_name: 'fred')

      page.to_url.should eq "<a href='/wilma/fred'>#{page.navlabel}</a>"
    end
  end

  describe '#parent_navlabel' do
    it 'should return the navlabel when it has a parent' do
      parent = FactoryGirl.create(:page, name: 'Parent', title: 'Parent',
                                  navlabel: 'Parent', body: '.')
      child = FactoryGirl.create(:page, name: 'Child', title: 'Child',
                                 navlabel: 'Child', body: '.',
                                 parent_id: parent.id)

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
      page = FactoryGirl.create(:page, redirect: true,
                                controller_name: 'page',
                                action_name: 'show')

      page.redirection.should eq 'page/show'
    end

    it 'should return None when not redirected' do
      page = FactoryGirl.create(:page)

      page.redirection.should eq 'None'
    end
  end

  describe '#invalidate_page_cache' do
    it 'touches all but the current page' do
      page1 = FactoryGirl.create(:page, admin: true)
      page2 = FactoryGirl.create(:page, parent: page1, admin: false)
      page3 = FactoryGirl.create(:page, parent: page1, admin: true)
      page4 = FactoryGirl.create(:page, parent: page1, admin: false)

      Page.should_receive(:all).and_return([page1, page2, page3, page4])
      page2.should_receive(:touch)
      page3.should_receive(:touch)
      page4.should_receive(:touch)

      page1.invalidate_page_cache
    end
  end

  context 'scopes' do
    describe '#find_main' do
      it 'finds all pages without parents' do
        page1 = FactoryGirl.create(:page, admin: true)
        FactoryGirl.create(:page, parent: page1, admin: true)

        Page.find_main.should eq [page1]
      end

      it 'sorts by position' do
        page1 = FactoryGirl.create(:page, admin: true, position: 3)
        page2 = FactoryGirl.create(:page, admin: false, position: 2)

        Page.find_main.should eq [page2, page1]
      end
    end

    describe '#find_main_public' do
      it 'finds non-admin pages without parents' do
        page1 = FactoryGirl.create(:page, admin: true)
        page2 = FactoryGirl.create(:page, admin: false)
        FactoryGirl.create(:page, parent: page1, admin: true)
        FactoryGirl.create(:page, parent: page2, admin: false)

        Page.find_main_public.should eq [page2]
      end

      it 'sorts by position' do
        FactoryGirl.create(:page, admin: true, position: 3)
        page2 = FactoryGirl.create(:page, admin: false, position: 2)
        page3 = FactoryGirl.create(:page, admin: false, position: 1)

        Page.find_main_public.should eq [page3, page2]
      end
    end
  end
end