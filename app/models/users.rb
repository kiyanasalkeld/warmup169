class Users < ActiveRecord::Base
  SUCCESS = 1 #The success return code

  ERR_BAD_CREDENTIALS = -1 #Cannot find the user/password pair in the database (for login only)

  ERR_USER_EXISTS = -2 #trying to add a user that already exists (for add only)

  ERR_BAD_USERNAME = -3 #invalid user name (empty or longer than MAX_USERNAME_LENGTH) (for add only)

  ERR_BAD_PASSWORD = -4 #invalid password name (longer than MAX_PASSWORD_LENGTH) (for add only)

  MAX_USERNAME_LENGTH = 128 #The maximum length of user name

  MAX_PASSWORD_LENGTH = 128 #The maximum length of the passwords

  #This function checks the user/password in the database.
  def self.login(username, password)
    user = self.find_by_username(username)
    if user.nil?
      return ERR_BAD_CREDENTIALS
    end
    if user.password != password
      return ERR_BAD_CREDENTIALS
    else
      user.count = user.count + 1
      user.save
      return user.count
    end
  end

  #This function checks that the user does not exists, the user name is not empty.
  #Add user to database, increase login count by 1
  #I originally had length checking occur in my controller's add method, but I had to move this functionality over to the model because my unit tests were failing
  def self.add(username, password)
    if username.length == 0 || username.length > MAX_USERNAME_LENGTH
      return ERR_BAD_USERNAME
    end
    if password.length > MAX_PASSWORD_LENGTH
      return ERR_BAD_PASSWORD
    end
    if self.find_by_username(username).nil?
      create!({:username => username,:password => password,:count => 1})
      return 1
    else
      return ERR_USER_EXISTS
    end



  end

  #This function is used only for testing, and should clear the database of all rows.
  def self.TESTAPI_resetfixture
    Users.delete_all
  end

end
