require 'test_helper'

class PhpbbTest < ActiveSupport::TestCase
  context "#has_role?" do
    context "photo_owner role" do
      should "return true if user is an owner of photo" do
        @user = PhpbbUser.make
        @photo = Photo.make :owner => @user
        assert @user.has_role?('photo_owner', @photo)
      end

      should "return false if user is not an owner of photo" do
        @user = PhpbbUser.make

        @photo = Photo.make :owner_id => PhpbbUser.make.id
        assert !@user.has_role?('photo_owner', @photo)

        @photo = Photo.make :owner_id => 0
        assert !@user.has_role?('photo_owner', @photo)
      end
    end
  end

  context "has_ads?" do
    should "return false if user has no ads" do
      @user = PhpbbUser.make
      
      assert !@user.has_ads?
    end

    should "return true if user has any" do
      @user = PhpbbUser.make
      @ad = Ad.make :user_id => @user.id
      assert @user.has_ads? 
    end

    should "return false if user had ads but deleted them" do
      @user = PhpbbUser.make
      @ad = Ad.make :user_id => @user.id
      @ad.remove
      assert !@user.has_ads?
    end
  end
end
