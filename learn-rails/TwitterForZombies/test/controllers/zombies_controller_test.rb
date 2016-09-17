require 'test_helper'

class ZombiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @zombie = zombies(:one)
  end

  test "should get index" do
    get zombies_url
    assert_response :success
  end

  test "should get new" do
    get new_zombie_url
    assert_response :success
  end

  test "should create zombie" do
    assert_difference('Zombie.count') do
      post zombies_url, params: { zombie: { age: @zombie.age, bio: @zombie.bio, name: @zombie.name } }
    end

    assert_redirected_to zombie_url(Zombie.last)
  end

  test "should show zombie" do
    get zombie_url(@zombie)
    assert_response :success
  end

  test "should get edit" do
    get edit_zombie_url(@zombie)
    assert_response :success
  end

  test "should update zombie" do
    patch zombie_url(@zombie), params: { zombie: { age: @zombie.age, bio: @zombie.bio, name: @zombie.name } }
    assert_redirected_to zombie_url(@zombie)
  end

  test "should destroy zombie" do
    assert_difference('Zombie.count', -1) do
      delete zombie_url(@zombie)
    end

    assert_redirected_to zombies_url
  end
end
