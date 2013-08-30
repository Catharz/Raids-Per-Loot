# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  fixtures :users, :services

  describe 'being created' do
    before do
      @user = nil
      @creating_user = lambda do
        @user = create_user
        if @user.new_record?
          violated "#{@user.errors.full_messages.to_sentence}"
        end
      end
    end

    it 'increments User#count' do
      @creating_user.should change(User, :count).by(1)
    end
  end

  #
  # Validations
  #

  it 'requires name' do
    lambda do
      u = create_user(name: nil)
      u.errors.get(:name).should_not be_nil
    end.should_not change(User, :count)
  end

  it 'requires email' do
    lambda do
      u = create_user(email: nil)
      u.errors.get(:email).should_not be_nil
    end.should_not change(User, :count)
  end

  describe 'allows legitimate names:' do
    ['Andre The Giant (7\'4", 520 lb.) -- has a posse',
     'fin', '1234567890_234567890_234567890_234567890_234567890_' +
            '234567890_234567890_234567890_234567890_234567890',
    ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_user(name: name_str)
          u.errors.get(:name).should be_nil
        end.should change(User, :count).by(1)
      end
    end
  end
  describe 'disallows illegitimate names' do
    ['wu',
     '1234567890_234567890_234567890_234567890_234567890_' +
         '234567890_234567890_234567890_234567890_234567890_',
    ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_user(name: name_str)
          u.errors.get(:name).should_not be_nil
        end.should_not change(User, :count)
      end
    end
  end

  protected
  def create_user(options = {})
    record = User.new({name: 'name', email: 'quire@example.com'}.
                          merge(options))
    record.save
    record
  end
end
