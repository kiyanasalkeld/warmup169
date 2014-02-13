require 'test_helper'


#I wrote these tests with help from http://guides.rubyonrails.org/testing.html#testing-templates-and-layouts
#I also used this page as reference http://api.rubyonrails.org/v3.2.13/classes/ActiveRecord/Fixtures.html
#Used this page for help as well http://www.hiringthing.com/2012/08/02/rails-testing-demystifying-test-unit.html#sthash.aQ6HkwsZ.dpbs
class UsersTest < ActiveSupport::TestCase

  SUCCESS = 1 #The success return code

  ERR_BAD_CREDENTIALS = -1 #Cannot find the user/password pair in the database (for login only)

  ERR_USER_EXISTS = -2 #trying to add a user that already exists (for add only)

  ERR_BAD_USERNAME = -3 #invalid user name (empty or longer than MAX_USERNAME_LENGTH) (for add only)

  ERR_BAD_PASSWORD = -4 #invalid password name (longer than MAX_PASSWORD_LENGTH) (for add only)

  MAX_USERNAME_LENGTH = 128 #The maximum length of user name

  MAX_PASSWORD_LENGTH = 128 #The maximum length of the passwords

  test "add an empty username" do
    test = Users.add("", "123")
    assert test == ERR_BAD_USERNAME
    Users.TESTAPI_resetfixture
  end

  test "add long password" do
    pwd = "test" * 100
    test = Users.add("kiyana", pwd)
    assert test == ERR_BAD_PASSWORD
    Users.TESTAPI_resetfixture
  end

  test "add long username" do
    username = "test" * 100
    test = Users.add(username, "123")
    assert test == ERR_BAD_USERNAME
    Users.TESTAPI_resetfixture
  end

  test "add blank password" do
    test = Users.add("test", "")
    assert test == SUCCESS
    Users.TESTAPI_resetfixture
  end

  test "add a normal user" do
    test = Users.add("kiyana","123")
    assert test == SUCCESS
    Users.TESTAPI_resetfixture
  end

  test "valid username wrong pwd" do
    Users.add("kiyana","123")
    test = Users.login("kiyana","124")
    assert test == ERR_BAD_CREDENTIALS
    Users.TESTAPI_resetfixture
  end

  test "wrong username valid pwd" do
    Users.add("kiyana","123")
    test = Users.login("test","123")
    assert test == ERR_BAD_CREDENTIALS
    Users.TESTAPI_resetfixture
  end

  test "add existing user" do
    Users.add("kiyana","123")
    test = Users.add("kiyana", "1234")
    assert test == ERR_USER_EXISTS
    Users.TESTAPI_resetfixture
  end

  test "initial count set 1" do
    Users.add("kiyana", "123")
    assert Users.find_by_username("kiyana").count == 1
    Users.TESTAPI_resetfixture
  end

  test "incrementing count" do
    Users.add("kiyana", "123")
    Users.login("kiyana", "123")
    assert Users.find_by_username("kiyana").count == 2
    Users.TESTAPI_resetfixture
  end

end