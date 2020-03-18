# Docker development setup

1) Install the Docker desktop application for your OS (https://www.docker.com/products/docker-desktop)

2) install stack_car: `gem install stack_car` in the terminal

3) We recommend committing .env to your repo with good defaults. .env.development, .env.production etc can be used for local overrides and should not be in the repo.

4) sc up

``` bash
gem install stack_car
sc up

```
# REU Manager v3

### Development setup
first make sure that you have docker installed. On Mac OS use docker for mac and on Windows use docker for windows.  
Once you start it check the preferences and make sure that is has at least 3 gb of ram allocated to it.
make sure to login to `docker login registry.gitlab.com` use your gitlab credentials to login.

1. git clone the repo from https://gitlab.com/notch8/reumanager and make sure you're on `master`
2. run `sc pull`
3. run `sc up`
4. once you have the containers up and running, open a new tab/winmdow in your terminal
5. run `docker-compose exec web bash` this will give you a console in the container running rails
6. run `rails db:create db:migrate db:seed` in the container
7. in a browser go to test.lvh.me:3000

to get to the new admin go to http://test.lvh.me:3000/reu_program/dashboard.
the seeds setup a program admin for you. email: admin@test.com password: testing123

To see the applicant flow:
1. Log in as an admin, and make sure the settings have the application start at some time in the past and the application deadline at a future date
2. Go to test.lvh.me:3000 and click the big green button to create a new user
3. once the form is submitted, go to either the terminal window running your docker instance, or `/log/development.log` and look a page or two from the bottom for something like an email, which should have a confirmation link in the form "http://lvh.me:3000/users/confirmation?confirmation_token=<token>"
4. visit that adress in your browser
5. log in as that applicant

# REU Manager v2

```bash
When creating a new instance of REU:
create a new branch that will be the 'master' of the new app
docker-compose build
sc up
docker-compose exec web bash
rake db:create db:migrate
rake db:seed settings:load
```

# Deploy a new release

``` bash
sc release {staging | production} # creates and pushes the correct tags
sc deploy {staging | production} # deployes those tags to the server
```

Releaese and Deployment are handled by the gitlab ci by default. See ops/deploy-app to deploy from locally, but note all Rancher install pull the currently tagged registry image
NSF REU Manager
==========
https://reumanager.com

## Setup
Use Ruby 2.1.1

Run '''rake settings:load''' to load snippets.

If you're having trouble with event_machine during bundle - use '''bundle config build.eventmachine --with-cppflags=-I$(brew --prefix openssl)/include'''

## Info
This program facilitates the application process for science oriented [NSF REU programs](http://www.nsf.gov/crssprgm/reu/) and is developed by the IT staff of the [UC San Diego Institute of Engineering in Medicine](https://iem.ucsd.edu/).

[REU Manager](https://reumanager.com) is built with [Ruby on Rails](http://rubyonrails.org/) and is completely free to host/maintain yourself.   You can see a demonstration of the site at: https://reumanager.com/new_demo .  You may login as the administrative user with the email admin@reumanager.com and the password DemoApp.

Below are instructions for those who wish to install and maintain the application using their own equipment.



RAILS_ENV=production bundle exec rake assets:precompile RAILS_RELATIVE_URL_ROOT=/rqi


1) On the status page, it is noted that both of the recommendations have been received after only submitting one. Yet the application is still correctly filed under "Awaiting Recommendations" in the admin interface.

2) The administrators cannot access the attached transcript. I receive an error when I click the link, "Sorry, there was a problem...The page you requested was not found. Return to the home page"


# Docker development setup

1) Install Docker.app

2) Get .env file from team member or copy it from .env-example and fill it out

3) gem install stack_car

4) sc up

``` bash
gem install stack_car
sc up

```

# Deploy a new release

``` bash
sc release {staging | production} # creates and pushes the correct tags
sc deploy {staging | production} # deployes those tags to the server
```

Releaese and Deployment are handled by the gitlab ci by default. See ops/deploy-app to deploy from locally, but note all Rancher install pull the currently tagged registry image
