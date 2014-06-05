# puppet-atd [![Build Status](https://travis-ci.org/treydock/puppet-atd.png)](https://travis-ci.org/treydock/puppet-atd)

This is the atd Puppet module.

## Support

Currently only supports Enterprise Linux based systems.

Adding support for other Linux distributions should only require
new variables being added to atd::params case statement.

## Usage

For a default at installation

    class { 'atd': }

## Development

### Dependencies

* Ruby 1.8.7
* Bundler

### Running tests

1. To install dependencies run `bundle install`
2. Run tests using `rake test`
