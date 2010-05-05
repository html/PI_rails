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
    end

    should "increase ad views count" do
      class ::X;end
      @ad = Ad.make
      @rec = PageInfo.record_for(@ad)
      old_views = @rec.views

      get :show, :id => @ad.id

      assert_template 'show'
      assert_equal old_views + 1, PageInfo.record_for(@ad).views
    end
  end
  
  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
    end
  end
  
  context "create action" do
    should "render new template when model is invalid" do
      Ad.any_instance.stubs(:valid?).returns(false)
      post :create, :ad => {}
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      Ad.any_instance.stubs(:valid?).returns(true)
      post :create, :ad => {}
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
      Ad.any_instance.stubs(:valid?).returns(false)
      put :update, :id => ad.id
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      Ad.any_instance.stubs(:valid?).returns(true)
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
end
