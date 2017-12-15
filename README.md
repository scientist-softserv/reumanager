# Docker development setup

1) Install Docker.app 

2) gem install stack_car

3) We recommend committing .env to your repo with good defaults. .env.development, .env.production etc can be used for local overrides and should not be in the repo.

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
