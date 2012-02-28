require File.dirname(__FILE__) + '/../spec_helper'
require File.join(Rails.root, 'lib', 'authenticated_test_helper.rb')
include AuthenticatedTestHelper
include ApplicationHelper
include UsersHelper

describe UsersHelper do
  before(:each) do
    @user = mock_user
  end
  
  describe "if_authorized" do 
    it "yields if authorized" do
      helper.should_receive(:authorized?).with('a','r').and_return(true)
      helper.if_authorized?('a','r'){|action,resource| [action,resource,'hi'] }.should == ['a','r','hi']
    end
    it "does nothing if not authorized" do
      helper.should_receive(:authorized?).with('a','r').and_return(false)
      helper.if_authorized?('a','r'){ 'hi' }.should be_nil
    end
  end
  
  describe "link_to_user" do
    it "should give an error on a nil user" do
      lambda { helper.link_to_user(nil) }.should raise_error('Invalid user')
    end
    it "should link to the given user" do
      helper.should_receive(:user_path).at_least(:once).and_return('/users/1')
      helper.link_to_user(@user).should have_selector("a[href='/users/1']")
    end
    it "should use given link text if :content_text is specified" do
      helper.link_to_user(@user, :content_text => 'Hello there!').should have_selector("a", :content => 'Hello there!')
    end
    it "should use the login as link text with no :content_method specified" do
      helper.link_to_user(@user).should have_selector("a", :content => 'user_name')
    end
    it "should use the name as link text with :content_method => :name" do
      helper.link_to_user(@user, :content_method => :name).should have_selector("a", :content => 'U. Surname')
    end
    it "should use the login as title with no :title_method specified" do
      helper.link_to_user(@user).should have_selector("a[title='user_name']")
    end
    it "should use the name as link title with :content_method => :name" do
      helper.link_to_user(@user, :title_method => :name).should have_selector("a[title='U. Surname']")
    end
    it "should have nickname as a class by default" do
      helper.link_to_user(@user).should have_selector("a.nickname")
    end
    it "should take other classes and no longer have the nickname class" do
      result = helper.link_to_user(@user, :class => 'foo bar')
      result.should have_selector("a.foo")
      result.should have_selector("a.bar")
    end
  end

  describe "link_to_login_with_IP" do
    it "should link to the login_path" do
      helper.link_to_login_with_IP().should have_selector("a[href='/login']")
    end
    it "should use given link text if :content_text is specified" do
      helper.link_to_login_with_IP('Hello there!').should have_selector("a", :content => 'Hello there!')
    end
    it "should use the login as link text with no :content_method specified" do
      helper.link_to_login_with_IP().should have_selector("a", :content => '0.0.0.0')
    end
    it "should use the ip address as title" do
      helper.link_to_login_with_IP().should have_selector("a[title='0.0.0.0']")
    end
    it "should by default be like school in summer and have no class" do
      helper.link_to_login_with_IP().should_not have_selector("a.nickname")
    end
    it "should have some class if you tell it to" do
      result = helper.link_to_login_with_IP(nil, :class => 'foo bar')
      result.should have_selector("a.foo")
      result.should have_selector("a.bar")
    end
    it "should have some class if you tell it to" do
      result = helper.link_to_login_with_IP(nil, :tag => 'abbr')
      result.should have_selector("abbr[title='0.0.0.0']")
    end
  end

  describe "link_to_current_user, When logged in" do
    before(:each) do
      helper.current_user = @user
    end
    it "should link to the given user" do
      helper.should_receive(:user_path).at_least(:once).and_return('/users/1')
      helper.link_to_current_user().should have_selector("a[href='/users/1']")
    end
    it "should use given link text if :content_text is specified" do
      helper.link_to_current_user(:content_text => 'Hello there!').should have_selector("a", :content => 'Hello there!')
    end
    it "should use the login as link text with no :content_method specified" do
      helper.link_to_current_user().should have_selector("a", :content => 'user_name')
    end
    it "should use the name as link text with :content_method => :name" do
      helper.link_to_current_user(:content_method => :name).should have_selector("a", :content => 'U. Surname')
    end
    it "should use the login as title with no :title_method specified" do
      helper.link_to_current_user().should have_selector("a[title='user_name']")
    end
    it "should use the name as link title with :content_method => :name" do
      helper.link_to_current_user(:title_method => :name).should have_selector("a[title='U. Surname']")
    end
    it "should have nickname as a class" do
      helper.link_to_current_user().should have_selector("a.nickname")
    end
    it "should take other classes and no longer have the nickname class" do
      result = helper.link_to_current_user(:class => 'foo bar')
      result.should have_selector("a.foo")
      result.should have_selector("a.bar")
    end
  end

  describe "link_to_current_user, When logged out" do
    before(:each) do
      helper.current_user = nil
    end
    it "should link to the login_path" do
      helper.link_to_current_user().should have_selector("a[href='/login']")
    end
    it "should use given link text if :content_text is specified" do
      helper.link_to_current_user(:content_text => 'Hello there!').should have_selector("a", :content => 'Hello there!')
    end
    it "should use 'not signed in' as link text with no :content_method specified" do
      helper.link_to_current_user().should have_selector("a", :content => 'not signed in')
    end
    it "should use the ip address as title" do
      helper.link_to_current_user().should have_selector("a[title='0.0.0.0']")
    end
    it "should by default be like school in summer and have no class" do
      helper.link_to_current_user().should_not have_selector("a.nickname")
    end
    it "should have some class if you tell it to" do
      result = helper.link_to_current_user(:class => 'foo bar')
      result.should have_selector("a.foo")
      result.should have_selector("a.bar")
    end
  end

end
