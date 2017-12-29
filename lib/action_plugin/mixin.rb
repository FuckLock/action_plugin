module ActionPlugin
  module Mixin
    extend ActiveSupport::Concern

    def validate_opts opts = {}
      return false if opts[:subject].blank? || opts[:action_type].blank?
      return false if opts[:target_id].blank? || opts[:target_type].blank?
      opts[:subject_id] = opts[:subject].id
      opts[:subject_type] = opts[:subject].class.name
      opts
    end

    def format_opts opts
      opts.extract!(:subject_id, :subject_type, :action_type, :target_type, :target_id)
    end

    module ClassMethods
      def initialize_params(subject_type, action_type, target_type)
        @subject_type = subject_type.to_s.classify
        @action_type = action_type.to_s
        @target_type = target_type.to_s.classify
        @subject_class = @subject_type.constantize
        @target_class = @target_type.constantize
        @subject = @subject_type.downcase
        @target = @target_type.downcase
        @options = { subject_type: @subject_type, action_type: @action_type, target_type: @target_type, target_class: @target_class }
      end

      def action_plugin(subject_type, action_type, target_type)
        initialize_params(subject_type, action_type, target_type)
        define_relations
      end

      def define_relations
        options = @options
        action_target_actions = [@action_type, @target, 'actions'].join('_').to_sym
        action_targets = [@action_type, @target].join('_').pluralize.to_sym
        action_subject_actions = [@action_type, @subject, 'actions'].join('_').to_sym
        action_subjects = [@action_type, @subject].join('_').pluralize.to_sym
        has_many_scope = -> {
          where(subject_type: options[:subject_type], action_type: options[:action_type], target_type: options[:target_type])
        }
        @subject_class.send(:has_many, action_target_actions, has_many_scope,
                            class_name: "Action", foreign_key: "subject_id")
        @subject_class.send(:has_many, action_targets, through: action_target_actions,
                            source: :target, source_type: @target_type)
        @target_class.send(:has_many, action_subject_actions, has_many_scope,
                            class_name: "Action", foreign_key: "target_id")
        @target_class.send(:has_many, action_subjects, through: action_subject_actions,
                            source: :subject, source_type: @subject_type)
        define_some_methods
      end

      def define_some_methods
        options = @options
        action_target = [@action_type, @target].join("_")
        unaction_target = "un#{action_target}"
        action_target_mark = "#{action_target}?"

        @subject_class.send(:define_method, action_target) do |target_or_id|
          target_id = target_or_id.is_a?(options[:target_class]) ? target_or_id.id : target_or_id
          Action.find_or_create_by( subject_id: self.id, subject_type: self.class.name,
                                    action_type: options[:action_type], target_id: target_id,
                                    target_type: options[:target_type]
                                  )
        end

        @subject_class.send(:define_method, action_target_mark) do |target_or_id|
          target_id = target_or_id.is_a?(options[:target_class]) ? target_or_id.id : target_or_id
          action = find_action(subject: self, action_type: options[:action_type],
                                target_id: target_id, target_type: options[:target_type]
                              )
          action.present?
        end

        @subject_class.send(:define_method, unaction_target) do |target_or_id|
          target_id = target_or_id.is_a?(options[:target_class]) ? target_or_id.id : target_or_id
          action = find_action(subject: self, action_type: options[:action_type],
                                target_id: target_id, target_type: options[:target_type])
          action.destroy
        end

        @subject_class.send(:define_method, "find_action") do |opts = {}|
          opts = validate_opts(opts)
          action = Action.find_by(format_opts(opts))
          action
        end
      end

    end
  end
end
