# Gifs

[![CircleCI](https://circleci.com/gh/trueheart78/gifs.svg?style=svg)](https://circleci.com/gh/trueheart78/gifs)

Gif management using Dropbox public links and Sqlite in a gem package. :heart:

Currently requires access to Dropbox via the `~/Dropbox` path. Expects a `~/Dropbox/gifs` directory storing gifs. This is also where the database file will be created, to track public Dropbox links for each gif.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gifs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gifs

## Dropbox Integration

First, you need to create a new Dropbox app, using the **Dropbox API** (not the business option), with **Full Dropbox** access. Once you have that setup, you will need to click the _Generate_ button beneath the **Generate Access Token** header of the **OAuth2** section. This is the token that will be used for interacting with your Dropbox account.

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gifs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Gifs project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/gifs/blob/master/CODE_OF_CONDUCT.md).
