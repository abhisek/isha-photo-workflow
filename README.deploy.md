Ruby Setup
----------

Install Ruby 1.9 and rubygems

Application Installation
-------------------------

Fetch the application source from github using the following command (assuming you have git installed, if not use: apt-get install git-core): 
```
git clone https://github.com/abhisek/isha-photo-workflow.git
```

The application source will be fetched in isha-photo-workflow directory under current directory.

Database Setup
---------------

* Create MySQL database
* Edit config/database.yml with database details
* The socket file path in database.yml might be adjusted as per your distro.
  Find the socket file path using the following commands:
    * locate mysql.sock
    * locate mysqld.sock

Dependency Installation
------------------------

* Install bundler gem
  * gem install bundler

* Go to the root (top-most) directory of the application and issue the following
  command to install required dependencies.

    * bundle install

If everything goes fine, you are ready for database schema setup.

Database Migration
------------------

* Setup the database schema using the following command:

  bundle exec rake db:migrate

  (The bundle command should be available if bundler gem is successfully installed)


Application Server
------------------

* Start the application server using the following command:

  bundle exec rails s -p 8080

This will start the application server on port 8080. Now you can browse the application
by visiting http://<IP>:8080/




