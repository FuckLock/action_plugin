module ActionPlugin
  module Mixin
    extend ActiveSupport::Concern

    module ClassMethods
      def init_params(subject_type, action_type, target_type)
        subject_type = subject_type.to_s.classify
        action_type = action_type.to_s
        target_type = target_type.to_s.classify
        subject_class = subject_type.constantize
        target_class = target_type.constantize
        subject = subject_type.downcase
        target = target_type.downcase
        action = {
          subject_class: subject_class,
          target_class: target_class,
          subject_type: subject_type,
          action_type: action_type,
          target_type: target_type,
          subject: subject,
          target: target
        }
      end

      def action_plugin(subject_type, action_type, target_type)
        action = init_params(subject_type, action_type, target_type)
        define_relations(action)
      end

      def define_relations(action)
        subject_class = action[:subject_class]
        target_class = action[:target_class]
        subject_type = action[:subject_type]
        target_type = action[:target_type]
        action_type = action[:action_type]
        subject = action[:subject]
        target = action[:target]
        action_target_actions = [action_type, target, 'actions'].join('_').to_sym
        action_targets = [action_type, target].join('_').pluralize.to_sym
        action_subject_actions = [action_type, subject, 'actions'].join('_').to_sym
        action_subjects = [action_type, subject].join('_').pluralize.to_sym
        has_many_scope = -> {
          where(subject_type: subject_type, action_type: action_type, target_type: target_type)
        }
        subject_class.send(:has_many, action_target_actions, has_many_scope,
                            class_name: "Action", foreign_key: "subject_id")
        subject_class.send(:has_many, action_targets, through: action_target_actions,
                            source: :target, source_type: target_type)
        target_class.send(:has_many, action_subject_actions, has_many_scope,
                            class_name: "Action", foreign_key: "target_id")
        target_class.send(:has_many, action_subjects, through: action_subject_actions,
                            source: :subject, source_type: subject_type)
        define_some_methods(action)
      end

      def define_some_methods(action)
        subject_class = action[:subject_class]
        target_class = action[:target_class]
        subject_type = action[:subject_type]
        target_type = action[:target_type]
        action_type = action[:action_type]
        subject = action[:subject]
        target = action[:target]
        action_target = [action_type, target].join("_")
        unaction_target = "un#{action_target}"
        action_target_mark = "#{action_target}?"
        subject_class.send(:define_method, action_target) do |target_or_target_id|
          subject_id = self.id
          target_id = target_or_target_id.is_a?(target_class) ? target_or_target_id.id : target_or_target_id
          Action.find_or_create_by(
            subject_id: subject_id,
            subject_type: subject_type,
            action_type: action_type,
            target_id: target_id,
            target_type: target_type
          )
        end

        subject_class.send(:define_method, "find_action") do |target_or_target_id|
          subject_id = self.id
          target_id = target_or_target_id.is_a?(target_class) ? target_or_target_id.id : target_or_target_id
          action = Action.find_by(
                    subject_id: subject_id,
                    subject_type: subject_type,
                    action_type: action_type,
                    target_id: target_id,
                    target_type: target_type
                  )
          action
        end

        subject_class.send(:define_method, action_target_mark) do |target_or_target_id|
          action = find_action(target_or_target_id)
          action.present?
        end

        subject_class.send(:define_method, unaction_target) do |target_or_target_id|
          action = find_action(target_or_target_id)
          action.destroy
        end
      end
    end

  end
end
