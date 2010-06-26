require 'test_helper'

class AdsControllerTest < ActionController::TestCase
  context "#transform_params" do
    should "be protected" do
      assert_raise NoMethodError do
        @controller.transform_params
      end
    end
  end

  context "index action" do
    should "redirect to :all action" do
      get :index
      assert_redirected_to '/all'
    end
  end
  
  context "show action" do
    should "render show template" do
      get :show, :id => Ad.make.id
      assert_template 'show'

      ['egeoxml', 'egeoxml_ext', 'ads_show'].each do |script|
        assert_javascript_not_loaded script
      end
    end

    should "increase ad views count" do
      @ad = Ad.make
      @rec = PageInfo.record_for(@ad)
      old_views = @rec.views

      get :show, :id => @ad.id

      assert_template 'show'
      assert_equal old_views + 1, PageInfo.record_for(@ad).views
    end

    should "not render place if there is point for Ad" do
      @ad = Ad.make :point => nil

      get :show, :id => @ad.id

      assert_select 'h5', :text => /Місце/, :count => 0
      assert_select '#mapContainer', :count => 0



      assert_egeoxml_not_loaded
      assert_javascript_not_loaded  'ads_show'
    end

    should "render place if there is no point for Ad" do
      @ad = Ad.make :point => Point.make

      get :show, :id => @ad.id

      assert_select 'h5', :text => /Місце/, :count => 1
      assert_select '#mapContainer', :count => 1

      assert_egeoxml_loaded
      assert_javascript_loaded 'ads_show'
    end
  end
  
  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
      
      assert_map_coord_choice_loaded
    end
  end
  
  context "create action" do
    should "render new template when model is invalid" do
      post :create, :ad => Ad.plan(:invalid)
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      post :create, :ad => Ad.plan
      assert_redirected_to ad_url(assigns(:ad))
    end
  end
  
  context "edit action" do
    should "render edit template" do
      get :edit, :id => Ad.make.id
      assert_template 'edit'
    end
  end
  
  context "update action" do
    should "render edit template when model is invalid" do
      ad = Ad.make
      put :update, :id => ad.id, :ad => Ad.plan(:invalid)
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      put :update, :id => Ad.make.id
      assert_redirected_to ad_url(assigns(:ad))
    end
  end
  
  context "destroy action" do
    should "destroy model and redirect to index action" do
      ad = Ad.make
      delete :destroy, :id => ad.id
      assert_redirected_to ads_url
      assert ad.public
    end
  end

  context "search action" do
    should "be displayed correctly" do
      assert_response :success
    end
  end

  context "my action" do
    should "be displayed correctly when not logged in" do
      get :my
      assert_response :success
      assert_template :by_tag
      assert_select '.article .item', 0
    end

    should "not display my_ads menu" do
      get :my
      assert_select '.submenu_item', 0
    end

    should "not display my_ads menu if we had some ads and deleted them" do
      login
      Ad.make(:user_id => @logged_user.id).remove

      get :my
      assert_select '.submenu_item', 0
    end

    should "be displayed correctly when logged in" do
      login
      get :my
      assert_response :success
      assert_template :by_tag
      assert_select '.article .item', 0
    end

    should "contain some items if user has ads" do
      login
      2.times do
        Ad.make :user_id => @logged_user.id
      end

      get :my
      assert_response :success
      assert_template :by_tag
      assert_select '.article .item', 2
    end

    should "be paginated" do
      login

      10.times do
        Ad.make :user_id => @logged_user.id
      end

      assert_paginated :selector => '.article .item', :items_per_page => 5, :try_pages => 2 do |i|
        get :my, :page => i
        assert_response :success
        assert_template :by_tag
      end
    end

    context "cookied ads" do
      should "contain some items if user has cookied ads" do
        2.times do |i|
          make_cookied_ad
        end

        get :my
        assert_select '.article .item', 2
      end

      should "be paginated" do
        10.times do |i|
          make_cookied_ad
        end

        get :my
        assert_select '.article .item', 5
      end

      should "display my_ads menu" do
        make_cookied_ad

        get :my
        assert_select '.submenu_item', 1
      end
    end
  end
end
