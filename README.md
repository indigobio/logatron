# Logatron

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logatron'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logatron

## Usage

### Severities
Severities are used to examine and filter server logs, create alerts, and analyze user behavior.

* Debug - use for fixing production bugs or deeper inspection into behavior
* Info - use for general information (successful operations, ec.)
* Invalid Use - use for user errors due to invalid inputs
* Warn - use for recoverable errors
* Error - use for known unrecoverable errors
* Critical - use for unknown unrecoverable errors (system-level rescues)
* Fatal - use for system errors

*Invalid Use* - inappropriate inputs from a user - are not immediately actionable for a development team, but may provide input into customer care, future features, or bug fixes for poorly implemented features. This makes them a discreet category above `INFO` so that any queries on the logs can be readily consumed by such information seekers.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/logatron. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

