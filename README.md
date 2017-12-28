# ActionPlugin

Plugin different kind of actions Like, Follow, Star ...

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'action_plugin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_plugin

## Usage

Generate Migrations:

$ rails g action_store:install

migration 20170208024704_create_actions.rb from action_plugin

## Define Actions

app/models/user.rb

class Subject < ActiveRecord::Base
  action_plugin subject_type, action_type, target_type
end

for example:

class User < ActiveRecord::Base
  action_plugin :User, :like, :Post
  action_plugin :User, :collection, :Topic
  action_plugin :Member, :like, :Topic
end

## some instance methods:
action_target_actions

action_targets

action_subject_actions

action_subjects

action_target?

for example:

action_plugin :User, :like, :Post -> generate instance methods:

@user.like_post_actions

@user.like_posts

@post.like_user_actions

@post.like_users

@user.like_post?
