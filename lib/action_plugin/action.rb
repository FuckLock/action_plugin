class Action < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :target, polymorphic: true
end
