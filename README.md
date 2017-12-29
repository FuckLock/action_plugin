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

```ruby
$ rails g action_store:install
```

```ruby
create migration 20170208024704_create_actions.rb
```

```ruby
rails db:migrate
```

## Define Actions

app/models/user.rb

```ruby
class Subject < ActiveRecord::Base
  action_plugin subject_type, action_type, target_type
end
```


for example:

```ruby
class User < ActiveRecord::Base
  action_plugin :User, :like, :Post
  action_plugin :User, :collection, :Topic
  action_plugin :Member, :like, :Topic
end
```

## some instance methods:

```ruby
for example:

class User < ActiveRecord::Base
  action_plugin :User, :like, :Topic
end

If you have the definition above the following methods are generated

# Returns the actions of all the topics that this user likes
@user.like_topic_actions

# Return to all the topics that this user likes
@user.like_topics

# Return to all the topic id that this user likes
@user.like_topic_ids

# Return all user actions that like this topic
@topic.like_user_actions

# Returns all users who like the topic
@topic.like_users

# Returns all user id who like the topic
@topic.like_user_ids

# Users like to create an action record
@user.like_topic @topic

#The user does not like the topic to delete an action record
@user.unlike_topic @topic

#Do users like the theme
@user.like_topic? @topic

```
