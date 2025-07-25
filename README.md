# RubyRoles

Assign roles to users, accounts, user_accounts, and other models in a Ruby on Rails application.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add RubyRoles
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install RubyRoles
```

## Usage

```ruby
class MyModel < ApplicationRecord
  acts_as_ruby_roles
  roles :sysadmin, :syssupport # , ... << # NOTE: Never remove entries, never reorder entries, always add to the end of the list only
end
```

The default field used to store the roles is named "roles_mask", and it should be defined
in the ActiveRecord migration like so:

```ruby
  def change
    create_table :my_models do |t|
      # ...
      t.integer :roles_mask, default: 0, null: false
      # ...
    end
  end
```

or, after the table was previous created:

```ruby
  def change
    add_column :my_models, :roles_mask, :integer, default: 0, null: false
  end
```

If you want to change the name of the field, simply specify the field name in the 
acts_as_ruby_roles call in the model:

```ruby
class MyModel < ApplicationRecord
  acts_as_ruby_roles field_name: :my_alternate_roles_field_name
  roles :sysadmin, :syssupport, :viewonly # , ... << # NOTE: Never remove entries, never reorder entries, always add to the end of the list only
end
```

Once you have this defined, you will have methods like the following available to you:

```ruby
user = User.first
user.is_sysadmin?
user.is_syssupport?
user.is_viewonly?
```

To set the roles, use:

```ruby
user = User.first
user.roles= [:sysadmin]
user.roles= [:sysadmin,:syssupport]
user.roles= [:sysadmin,:viewonly]
user.save!
```

And all the roles can be read by:

```ruby
user = User.first
user.roles => [:sysadmin,:syssupport,...]
user.save!
```

In the database, roles are stored as integers.
The values will return true or false depending on if the specified bit is set in the integer roles_mask for the model instance.
The bits are defined sequentially in the "roles" call. So, in this example, :sysadmin
is the 0th bit (integer  value 1), and :syssupport is the 1st bit (integer value 2), and :viewonly
is the 2nd bit (integer value 4).

An instance can be multiple roles by bit-wise ORing the values together.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leeatchison/RubyRoles.

To build a new gem (authorized deployers only can do the push):

```bash
gem build RubyRoles.gemspec
gem push RubyRoles-#.#.#.gem
```
