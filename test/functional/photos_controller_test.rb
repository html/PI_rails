require 'test_helper'

class PhotosControllerTest < ActionController::TestCase

  def assert_contains_images
    assert_select '.fl.p5'  do |tag|
      assert_select tag[0], '.w100.h100'
      @url = "http://photos.#{APPLICATION_HOST}/delete/#{Photo.last.id}"
      assert_select tag[0], 'a.link[href=?]', @url, :text => "Видалити"
    end
  end

  def assert_contains_image_without_delete_link
    assert_select '.fl.p5' do |tag|
      assert_select tag[0], '.w100.h100'
      assert_select tag[0], 'a.link', { :text => "Видалити", :count => 0 }
    end
  end

  # Replace this with your real tests.
  context "index action" do
    should "be rendered and paginated" do
      4.times do
        Photo.make :public => true
      end

      stub(AppConfig).photos_per_page { 2 }

      assert_paginated :selector => '.h100.w100', :items_per_page => 2, :try_pages => 2 do |i|
        get :index, :page => i
        assert_response :success
        assert_not_nil assigns(:photos)
        assert_not_nil assigns(:show_map)

        assert_contains_image_without_delete_link
      end
    end

    should "show message if there are no photos" do
      get :index
      assert_response_contains "Немає фотографій", 1
    end

    should "have correct title" do
      get :index
      assert_title_equals 'Фотогалерея'
    end

    should "show right block with link to add photo when logged in" do
      login
      get :index
      assert_contains_right_block do |tag|
        assert_select tag[0], 'a#add_image'
      end
    end

    should "not show right block with link to add photo when not logged in" do
      get :index
      assert_contains_right_block do |tag|
        assert_select tag[0], 'a#add_image', 0
      end
    end

    should "show link to my photos" do
      get :index
    end
  end

  context "my action" do
    should "deny when not logged in" do
      get :my
      assert_access_denied
    end

    should "be rendered and paginated" do
      login

      4.times do
        Photo.make :public => true, :owner_id => @logged_user.id
      end
      
      assert_paginated :selector => '.h100.w100', :items_per_page => 2, :try_pages => 2 do |i|
        stub(AppConfig).photos_per_page { 2 }
        login
        get :my, :page => i
        assert_response :success
        assert_not_nil assigns(:photos)
        assert_not_nil assigns(:show_map)

        assert_select '.fl.p5'  do |tag|
          assert_select tag[0], '.w100.h100'
          @url = "http://photos.#{APPLICATION_HOST}/delete/"
          assert_select tag.last, 'a.link[href^=?]', @url, :text => "Видалити"
        end
      end
    end

    should "show message if there are no photos" do
      login
      Photo.delete_all

      get :my

      assert_response :success
      assert_response_contains "Немає фотографій", 1
    end

    should "have correct title" do
      login
      get :my 
      assert_title_equals 'Фотогалерея - мої фотографії'
    end

    should "contain link to delete photo and checkbox for publishing on site" do
      login 
      Photo.make :owner_id => @logged_user.id

      get :my

      assert_contains_images
    end

    context "<my photos> link" do
      should "be visible  when there are some photos" do
        login
        Photo.make :owner_id => @logged_user.id, :public => true

        get :my
        
        assert_select '.submenu_item a', :text => 'Мої фотографії', :count => 1
      end

      should "not be visible when there are no photos" do
        login
        get :my

        assert_select '.submenu_item a', :text => 'Мої фотографії', :count => 0
      end
    end
  end

  context "add action" do
    should "add photo with public and owner_id attributes" do
      login
      Photo.delete_all
      post :add, :photo => { :image => fixture_file_upload('correct_image.png', 'image/png') }

      assert(eval(JSON.parse(@response.body)['success']))
      assert_equal 1, Photo.count

      @photo = Photo.last
      assert @photo.public
      assert_equal @logged_user.id, @photo.owner_id
    end

    should "not be available for unauthorized" do
      post :add, :photo => { :image => fixture_file_upload('correct_image.png', 'image/png') }

      assert_access_denied
    end
  end

  context "destroy action" do
    should "softly delete photo" do
      login
      @photo = Photo.make :public => true, :owner_id => @logged_user.id

      get :destroy, :id => @photo.id
      assert_redirected_to "/my"
      assert !@photo.reload.public
    end

    should "respond with not_found error" do
      login

      get :destroy, :id => nil

      assert_not_found
    end
    
    should "be denied when not logged in" do
      get :destroy, :id => Photo.make.id

      assert_access_denied
    end
  end
end
