# frozen_string_literal: true

require 'active_support'
require 'active_record'
require 'active_support/concern'
require "ruby_roles/version"
require "ruby_roles/concerns/roles_mgmt"
require "ruby_roles/acts_as_ruby_roles/instance_methods"
require "ruby_roles/acts_as_ruby_roles/class_methods"

module RubyRoles
  class Error < StandardError; end

  class Railtie < Rails::Railtie
    initializer 'RubyRoles.acts_as_ruby_roles' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.extend RubyRoles::ActsAsRubyRoles::ClassMethods
      end
    end
  end
end
