# DOCUMENTATION

## Technical stuff
* Ruby Version: ruby 2.4.0
* Rails Version: Rails 5.1.1
* RVM: Ruby enVironment Manager 1.29.1

## Gems used
* devise_token_auth
* cancancan
* firebase
* rspec

## Entity Relationship Diagram

![Screen_Shot_2017-06-06_at_9_26_19_PM.png](https://bitbucket.org/repo/gkyRKB9/images/1190701887-Screen_Shot_2017-06-06_at_9_26_19_PM.png)

## Endpoints
![Screen Shot 2017-06-07 at 3.05.05 PM.png](https://bitbucket.org/repo/gkyRKB9/images/2644189645-Screen%20Shot%202017-06-07%20at%203.05.05%20PM.png)

Swagger is not configured to reach the endpoints properly, just use it as a guide to know which endpoints are available and the structure for those.

## Things to consider

* There is only one admin user: email: amartinez@strv.com password: 12345678
* [The headers follow the RFC 6750 Bearer Token format](https://github.com/lynndylanhurley/devise_token_auth#token-header-format). You need to pass to each request 5 headers:
![Screen Shot 2017-06-07 at 5.02.53 PM.png](https://bitbucket.org/repo/gkyRKB9/images/2748100187-Screen%20Shot%202017-06-07%20at%205.02.53%20PM.png)
* Every response will provide a new token and expiry which you should use for the next request.
* You have the ability to associate multiple organizations registering a new user (By default it will be a regular user), to do that you should pass:
![Screen Shot 2017-06-07 at 5.11.00 PM.png](https://bitbucket.org/repo/gkyRKB9/images/455869005-Screen%20Shot%202017-06-07%20at%205.11.00%20PM.png)

### Things to improve
* Implement some representer pattern through a gem like ROAR or any similar, you will see null values in the properties in the response if they are not set.