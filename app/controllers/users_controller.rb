class UsersController < ApplicationController
  SUCCESS = 1 #The success return code

  ERR_BAD_CREDENTIALS = -1 #Cannot find the user/password pair in the database (for login only)

  ERR_USER_EXISTS = -2 #trying to add a user that already exists (for add only)

  ERR_BAD_USERNAME = -3 #invalid user name (empty or longer than MAX_USERNAME_LENGTH) (for add only)

  ERR_BAD_PASSWORD = -4 #invalid password name (longer than MAX_PASSWORD_LENGTH) (for add only)

  MAX_USERNAME_LENGTH = 128 #The maximum length of user name

  MAX_PASSWORD_LENGTH = 128 #The maximum length of the passwords

  def login
    username = params[:user]
    password = params[:password]
    count = Users.login(username, password)
    if count == ERR_BAD_CREDENTIALS
      render json: {errorCode: ERR_BAD_CREDENTIALS}
    else
      render json: {errorCode: SUCCESS, count: count}
    end
  end

  def add
    username = params[:user]
    password = params[:password]
    result = Users.add(username, password)
    if result == 1
      render json: {errorCode: SUCCESS, count: result}
    else
      render json: {errorCode: result}
    end

 end

  def reset_fixture
    Users.TESTAPI_resetfixture
    render json: {errorCode: SUCCESS}
  end

  def unit_tests
    test_output = 'ruby -Itest test/unit/users_test.rb'

    render json: {output: test_output}
  end

end
