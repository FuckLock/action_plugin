require "action_plugin/version"
require "action_plugin/mixin"
require "action_plugin/action"

module ActionPlugin
end

ActiveSupport.on_load(:active_record) do
  include ActionPlugin::Mixin
end
