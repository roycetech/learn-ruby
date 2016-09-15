Overview:
=========

This project is based on the CodeSchool course [Rails for Zombies Redux](https://www.codeschool.com/courses/rails-for-zombies-redux) and [Testing with RSpec](https://www.codeschool.com/courses/testing-with-rspec)


Project Features:
=================

01. Basic CRUD, MVC, REST, Data Validation, Form Submission with redirect
02. HTML, JSON, XML response
03. Custom URL, URL Parameters
04. Flash
05. Partials - reusable view section
06. Table one to many association
07. Cascade delete
08. Basic Authentication
09. Pre-action method
10. Twitter Bootstrap
11. Display Relative Creation Time
12. Live-Reload on changes to `view/` folder
13. Passing local variable to a partial page.

Testing Features:
-----------------

01. RSpec from CodeSchool course
02. Configured RSpec to mock with mocha
03. Matcher using regular expression
04. Checkig an item to be part of a collection



This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

- Use sunburst theme for sublime text 2


* Database creation

Preload data with
```
$ rails db:seed
```


* Database initialization

* How to setup rspec and mocha test.

- Modify `Gemfile` to include `rspec-rails`, `mocha`, `rspec-collection_matchers` under the group `:development`, `:test`
- run the command `$ bundle install`
- run the command `rails generate rspec:install`
- require the `spec/rails_helper`



* How to run the test suite


* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
