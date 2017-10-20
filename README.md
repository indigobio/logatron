# Logatron

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logatron'
```

If running logatron in rails, you will need to add the following line as well.

```ruby
gem 'lograge' # needed for rails projects using logatron
```

The reason lograge is not included as a transitive dependency automatically via
logatron is that lograge is only needed when logatron is used in rails. Lograge
includes many rails-ish dependencies that are unnecessary if not running in a
rails environment.

## Usage

### Configuration in Rails

The goal: constrain all configuration regarding the logging to go through
logatron and not the internals of logatron (such as lograge). Consumers of
logatron should not have to know the internals.

Logatron must be configured before anything else since there can be other
configuration dependent upon those values (lograge for sure). This is done by
doing that configuration in an initializer file that will be listed first when
sorted in that directory alphanumerically. Putting an underscore (`_`) in front
of the name typically will move it to the top of the list -
`config/initializers/_log.rb`. Here is an example configuration.

```ruby
require 'logatron/logatron'

Logatron.configure do |config|
  config.host = `hostname`.chomp
  config.app_id = 'my_app_name'
  config.logger = Logger.new(STDOUT)
  config.level = Logatron::INFO
  config.base_controller_class = 'ActionController::Base' # or 'ActionController::API' or 'ApplicationController'
  config.add_rails_request_field(:user_agent, &:user_agent)  # optional
end
```

All the configuration fields above are required with the exception of
`.add_rails_request_field`.

#### add_rails_request_field (optional)

`.add_rails_request_field` is an extension point for the auto-logging of rails
HTTP requests. If there is an additional parameter needed in the log line of the
rails HTTP request, that can be specified here. The first argument is the name
you want that new field to have in the rails HTTP request log line. The second
argument is a block that takes `ActionDispatch::Request` as an optional
parameter and returns the value to put next to the display name in the rails
HTTP request log line. The `.add_rails_request_field` method can be called 0 or
more times, once per additional field to put in the log line.

As of now, any additional fields added to the rails HTTP request log line affect
all routes in all controllers. There is no way currently to log extra fields on
specific controller actions. In other words, the configuration is global to all
routes.

#### base_controller_class

Choose a base class that all the controllers of the application extend.
Typically, this would be `ActionController::Base`. However, if using rails 5 as
an API server, it could be `ActionController::API`. If your rails application
has the typical `ApplicationController` that all your other controllers extend,
then that controller name would work as well. For an explanation of why this
property is required, see the [How it Works] section.

### Severities

Severities are used to examine and filter server logs, create alerts, and
analyze user behavior.

* Debug - use for fixing production bugs or deeper inspection into behavior
* Info - use for general information (successful operations, ec.)
* Invalid Use - use for user errors due to invalid inputs
* Warn - use for recoverable errors
* Error - use for known unrecoverable errors
* Critical - use for unknown unrecoverable errors (system-level rescues)
* Fatal - use for system errors

*Invalid Use* - inappropriate inputs from a user - are not immediately
 actionable for a development team, but may provide input into customer care,
 future features, or bug fixes for poorly implemented features. This makes them
 a discrete category similar to `INFO` so that any queries on the logs can be
 readily consumed by such information seekers.

### How it Works

Logatron, when deployed in a non-rails environment, acts as a simple logger.
When deployed in a rails environment, the `logatron/railtie` is loaded. This
railtie uses the gem lograge under the hood. It is lograge that is used to write
the one-line rails HTTP request log line. Logatron works to do all the
configuration necessary of both lograge and payload methods off the base
controller class.

Perhaps the most non-intuitive operation the logatron railtie does is perform an
"around alias" on the `.append_info_to_payload` method in the base controller
specified in the logatron configuration (see `lib/logatron/railtie.rb`). This
method is part of the `ActiveSupport::Notifications` code mixed in the
`ActionController` in rails by default. Lograge depends upon this notification
code as a trigger to write the rails HTTP request log line.

The around-aliasing of the `.append_info_to_payload` was done so that consumers
of logatron do not need to concern themselves with specifying that method
themselves.

## Testing

There is one test worthy of note, `spec/lib/logatron/railtie_spec.rb`. This test
launches a real rails application via the gem combustion. Any necessary files in
addition to a typical rails application are specified in the folder
`spec/internal`. It is here you can see the configuration of logatron specified
in the `_log.rb` file. The downside of this testing is that rails can be
initialized only one time, so only one rspec scenario is testing the railtie.

[How it Works]: #how_it_works
