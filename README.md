# Myjson

Ruby client for Myjson http://myjson.com

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-myjson'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-myjson

## Usage

### Myjson client

```Ruby
bin = Myjson::Bin.new
bin.show(id) # { 'hello' => 'world' }

bin.create(hello: 'world') # { 'uri' => 'https://api.myjson.com/bins/:id' }

bin.update(id, hello: 'world') # { 'hello' => 'world' }
```

### Myjson resource

```Ruby
require 'myjson/resource'

class MyKlass
  include Myjson::Resource
  
  myjson_attribute :name, String
  myjson_attribute :age, Integer
end

my_instance = MyKlass.new
my_instance.name = 'Jhon'
my_instance.save # create new record

id = my_instance.id
my_instance = MyKlass.find(id)

my_instance.age = 28
my_instance.save # update existing record
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nikitachernov/ruby-myjson. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

