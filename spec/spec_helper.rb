require 'puppetlabs_spec_helper/module_spec_helper'

begin
  require 'simplecov'
  require 'coveralls'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter '/spec/'
  end
rescue Exception => e
  warn "Coveralls disabled"
end

shared_context :defaults do  
  let :default_facts do
    {
      :osfamily => 'RedHat',
    }
  end
end

at_exit { RSpec::Puppet::Coverage.report! }
