Ruby Setup
----------

Install Ruby 1.9 and rubygems

Application Installation
-------------------------

Fetch the application source from github using the following command 
(assuming you have git installed, if not use: *apt-get install git-core*): 
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

```
bundle exec rails s -p 8080
```

This will start the application server on port 8080. Now you can browse the application
by visiting http://<IP>:8080/

If you experience slowdown in the application, run the application in production mode:

* Compile Assets:
```
rake assets:precompile
```
* Start Application Server in production mode:
```
bundle exec rails s -p 8080 -e production
```

Remote Update
--------------

Do take a database backup before attempting to update anything:
```
mysqldump -u user -p database > backup.sql
```

In order to deploy updates, issue the following command:

```
git pull -u
```
This assumes you have installed (fetched sources) the application using git as mentioned previously in this document.
Once sources are update, issue the following command to update the database schema:
```
rake db:migrate
```

Restart the application by killing all "rails" processes and following *Application Server* section.



