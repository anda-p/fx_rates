# FxRates

A library for getting foreign exchange rates.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fx_rates'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fx_rates

## Usage

For getting an exchange rate:

```ruby
my_exchange_rate = FxRates::ExchangeRate.new(MyRatesDataSource.new)

my_exchange_rate.at(Date.today, "USD", "GBP")
```

All arguments should be specified or an ArgumentError will be raised.

If there is no rate for a specified date or currency, a RateNotFoundError will be raised.

### Configuring the rates data source

As the data source for exchange rates can change, this should be passed in as an argument when creating an ExchangeRate instance:

```ruby
my_exhange_rate = ExchangeRate.new(MyRatesDataSource.new)
```

All data sources must extend the RatesDataSource class and provide the following methods

```ruby
load_rates
```

which refreshes the rates data 

```ruby
rates
```

which returns a Hash of rates in the format

```ruby
{date1 => {ccy1 => rate1, ccy2 => rate2}, date2 => {ccy1 => rate1, ccy2 => rate2}}
```
where the date keys are of type Date and currency and rate are strings.

The base currency for a data source that all the other rates are calculated relatively to should also appear in the hash as a value of 1.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fx_rates. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FxRates project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/fx_rates/blob/master/CODE_OF_CONDUCT.md).
