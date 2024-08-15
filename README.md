# Loops Ruby SDK

## Introduction

This is the official Ruby SDK for [Loops](https://loops.so), an email platform for modern software companies.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG

## Usage

In an initializer, import and configure the SDK:

```ruby
# config/initializers/loops.rb

require "loops_sdk"

LoopsSdk.configure do |config|
  config.api_key = '3d264d10f6688b19150bbb46c9223e23'
end
```

```ruby
begin

  response = LoopsSdk::Transactional.send(
    transactional_id: "closfz8ui02yq......",
    email: "dan@loops.so",
    data_variables: {
      loginUrl: "https://app.domain.com/login?code=1234567890"
    }
  )

  render json: response

rescue LoopsSdk::APIError => e
  # Do something if there is an error from the API
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Loops-so/loops-rb.
