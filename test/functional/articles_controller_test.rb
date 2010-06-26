require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  context "index action" do
    should "render index template" do
      get :index
      assert_template 'index'
    end
  end
  
  context "show action" do
    should "render show template" do
      get :show, :id => Article.make.id
      assert_template 'show'
    end
  end
  
  context "new action" do
    should "render new template" do
      login_as_admin
      get :new
      assert_template 'new'
    end

    should "not be rendered when not logged in" do
      post :create
      assert_access_denied
    end
  end
  
  context "create action" do
    #XXX: Article cannot be invalid
    if false
    should "render new template when model is invalid" do
      login_as_admin
      Article.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    end
    
    should "redirect when model is valid" do
      login_as_admin

      post :create, :article => Article.plan
      assert_redirected_to article_url(assigns(:article))
    end

    should "not be rendered when not logged in" do
      post :create
      assert_access_denied
    end
  end
  
  context "edit action" do
    should "render edit template" do
      login_as_admin
      get :edit, :id => Article.make.id
      assert_template 'edit'
    end

    should "not be rendered when not logged in" do
      get :edit, :id => Article.make.id
      assert_access_denied
    end
  end
  
  context "update action" do
    #XXX article can not be invalid
    if false
    should "render edit template when model is invalid" do
      login_as_admin
      article = Article.make

      put :update, :id => article.id, :article => Article.plan(:invalid)
      assert_template 'edit'
    end
    end
  
    should "redirect when model is valid" do
      login_as_admin

      put :update, :id => Article.make.id

      assert_redirected_to article_url(assigns(:article))
    end

    should "not be rendered when not logged in" do
      put :update, :id => Article.make.id
      assert_access_denied
    end
  end
  
  context "destroy action" do
    should "destroy model and redirect to index action" do
      login_as_admin
      article = Article.make
      delete :destroy, :id => article.id
      assert_redirected_to articles_url
      assert !Article.exists?(article.id)
    end

    should "not be rendered when not logged in" do
      delete :destroy, :id => Article.make.id
      assert_access_denied
    end
  end

  context "css action" do
    should "be with valid route" do
      assert_routes_equal "http://articles.#{APPLICATION_HOST}/css", :controller => 'articles', :action => 'css'
    end
  end
end
