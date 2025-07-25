# lib/ruby_roles/acts_as_ruby_roles/class_methods.rb
module RubyRoles
  module ActsAsRubyRoles
    extend ActiveSupport::Concern
    module ClassMethods
      def acts_as_ruby_roles(options = {})
        include RubyRoles::ActsAsRubyRoles::InstanceMethods
        include RubyRoles::Concerns::RolesMgmt
        # Initialize the class instance variables
        @roles_field_name = options[:field_name] if options[:field_name].present?
      end
    end
  end
end
