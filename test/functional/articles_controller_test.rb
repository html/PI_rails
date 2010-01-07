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
      get :show, :id => Article.first
      assert_template 'show'
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
      Article.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      Article.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to article_url(assigns(:article))
    end
  end
  
  context "edit action" do
    should "render edit template" do
      get :edit, :id => Article.first
      assert_template 'edit'
    end
  end
  
  context "update action" do
    should "render edit template when model is invalid" do
      Article.any_instance.stubs(:valid?).returns(false)
      put :update, :id => Article.first
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      Article.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Article.first
      assert_redirected_to article_url(assigns(:article))
    end
  end
  
  context "destroy action" do
    should "destroy model and redirect to index action" do
      article = Article.first
      delete :destroy, :id => article
      assert_redirected_to articles_url
      assert !Article.exists?(article.id)
    end
  end
end
