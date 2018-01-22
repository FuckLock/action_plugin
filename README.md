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
$ rails g action_plugin:install
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
for example one:

# Users like topic can be defined as follows.
class User < ActiveRecord::Base
  action_plugin :User, :like, :Topic
end

If you have the definition above the following methods are generated

# Returns the actions of all the topics that this user likes
@user.likeing_topic_actions

# Return to all the topics that this user likes
@user.likeing_topics

# Return to all the topic id that this user likes
@user.likeing_topic_ids

# Return all user actions that like this topic
@topic.likeed_user_actions

# Returns all users who like the topic
@topic.likeed_users

# Returns all user id who like the topic
@topic.likeed_user_ids

# Users like to create an action record
@user.like_topic @topic

#The user does not like the topic to delete an action record
@user.unlike_topic @topic

#Do users like the theme
@user.like_topic? @topic

```

```ruby

for example two:

# Users can follow the definition of other people.
class User < ActiveRecord::Base
  action_plugin :User, :follow, :User
end

If you have the definition above the following methods are generated

# Returns current_user following other people relations
current_user.following_user_actions

# Return current_user following all users
current_user.following_users

# Return current_user following all user ids
current_user.following_user_ids

# Return All user relationships that the user is concerned with
user.followed_user_actions

# Returns All users that the user is concerned about.
user.followed_users

# Returns all user followed user ids
user.followed_user_ids

# Users follow to create an relation
current_user.follow_user user

#The user does not unfollow the user to delete an relation
current_user.unfollow_user user

#Do users follow the theme
current_user.follow_user? user

```
