module RubyRoles
  module Concerns
    module RolesMgmt
      extend ActiveSupport::Concern


      included do
        @role_list = []

        #
        #
        # Class Methods
        #
        #

        # Sets the acceptable list of Roles
        def self.roles(*roles_list)
          @role_list = canonical_syms *roles_list
          @role_list.each do |method|
            define_method "is_#{method}?" do
              self.has_role? method
            end
          end
        end

        # Returns the list of acceptable roles
        def self.valid_roles
          @role_list
        end

        # Returns the bit mask for a given set of roles
        def self.mask_for(*roles_list)
          roles_syms_to_bits(*roles_list)
        end

        # Roles Display Management
        # Returns [["Role xxx",1],["Role xxx",2],["Role xxx",4]]
        def self.roles_array(*hidden_roles)
          hidden = canonical_syms(hidden_roles)||[]
          @roles_array_cache ||= {}
          @roles_array_cache[hidden.to_s] ||=
            @role_list.reject do |role|
              hidden.include? role
            end.map do |role|
              [ self.role_human_readable(role), self.roles_syms_to_bits(role) ]
            end.compact
        end

        # Return human readable string from role
        def self.role_human_readable(role)
          I18n.t("roles.names.#{role}")
        end
        # Return list of human readable strings matching the roles
        def roles_human_readable
          self.class.roles_bits_to_syms(self.roles_mask).map { |role|self.class.role_human_readable role }
        end


        #
        #
        # Private Methods
        #
        #
        private

        # Support: Turn a list/array of values into a simple flat array of symbols
        def self.canonical_syms(*syms)
          return nil if syms.nil?
          [ *syms ].flatten.map { |sym|sym.to_sym }
        end

        # Support: Turn a list of symbols into a bitmask
        def self.roles_syms_to_bits(*syms)
          (canonical_syms(*syms) & @role_list).map { |r| 2**@role_list.index(r) }.inject(0, :+)
        end

        # Support: Turn a bits mask into a list of symbols
        def self.roles_bits_to_syms(bits)
          @role_list.reject do |r|
            ((bits.to_i||0)&2**@role_list.index(r)).zero?
          end
        end
      end


      #
      #
      # Instance Methods
      #
      #

      # Set the valid set of roles for a given user
      def roles=(*roles)
        self.roles_mask = self.class.roles_syms_to_bits(*roles)
        self.roles
      end

      # Return the list of roles this user has
      def roles
        self.class.roles_bits_to_syms(roles_mask)
      end

      # Returns TRUE if user has this specific role
      def has_role?(role)
        (self.roles_mask & self.class.roles_syms_to_bits(role)) !=0
      end

      # Returns TRUE if user has any of the specified roles
      def has_any_roles?(*roles)
        (self.roles_mask & self.class.roles_syms_to_bits(*roles)) !=0
      end

      # Returns TRUE if user has all the specified roles
      def has_all_roles?(*roles)
        bits = self.class.roles_syms_to_bits(*roles)
        (self.roles_mask & bits) == bits
      end

      def add_roles(*roles)
        self.roles_mask = (self.roles_mask||0) | self.class.roles_syms_to_bits(*roles)
        self.roles
      end
      def delete_roles(*roles)
        self.roles_mask = (self.roles_mask||0) & ~self.class.roles_syms_to_bits(*roles)
        self.roles
      end
    end
  end
end