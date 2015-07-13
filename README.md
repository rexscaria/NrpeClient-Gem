# Nrpeclient

This gem is an alternative for the check_nrpe plugin in Nagios to execute commands at the remote machines where the NRPE daemon is running.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nrpeclient'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nrpeclient

## Usage

```
  require 'nrpeclient'
  request = Nrpeclient::CheckNrpe.new({:host=> 'hostname', :port=> '5666', :ssl => true})
  response = request.send_command('command', 'arg1', 'arg2'..)
  #Command result
  puts response.buffer

  #Return value
  puts response.result_code


```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nrpeclient. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
