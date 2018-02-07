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
my_exchange_rate = ExchangeRate.new(MyRatesDataSource.new)
```

All data sources must extend the RatesDataSource class and provide the following methods.

```ruby
load_rates
```

which refreshes the rates data 

```ruby
rates
```

which returns all the rates data. For the ECB source it is a Hash of rates in the format

```ruby
{date1 => {ccy1 => rate1, ccy2 => rate2}, date2 => {ccy1 => rate1, ccy2 => rate2}}
```
where the date keys are of type Date and currency and rate are strings.

```ruby
rate_for_date_and_ccy
```
which gets the rate for a date and currency and is used in the calculations instead of the whole rates data so we don't depend on a particular data representation.


The base currency for a data source that all the other rates are calculated relatively to should also appear in the hash as a value of 1.

An already implemented data source is the European Central Bank and can be used by calling

```ruby
my_exchange_rate = ExchangeRate.new(ECBRatesDataSource.new)
```

