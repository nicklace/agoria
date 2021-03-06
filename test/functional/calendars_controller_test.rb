require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Calendar.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Calendar.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to calendars_url
  end

  def test_edit
    get :edit, :id => Calendar.first
    assert_template 'edit'
  end

  def test_update_invalid
    Calendar.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Calendar.first
    assert_template 'edit'
  end

  def test_update_valid
    Calendar.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Calendar.first
    assert_redirected_to calendars_url
  end
end
