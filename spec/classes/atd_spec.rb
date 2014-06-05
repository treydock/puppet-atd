require 'spec_helper'

describe 'atd' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('atd') }
  it { should contain_class('atd::params') }

  it do
    should contain_package('at').with({
      'ensure'  => 'present',
      'name'    => 'at',
      'before'  => 'File[/etc/sysconfig/atd]',
    })
  end

  it do
    should contain_service('atd').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'atd',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
      'subscribe'   => 'File[/etc/sysconfig/atd]',
    })
  end

  it do
    should contain_file('/etc/sysconfig/atd').with({
      'ensure'    => 'file',
      'path'      => '/etc/sysconfig/atd',
      'owner'     => 'root',
      'group'     => 'root',
      'mode'      => '0644',
    })
  end

  it do
    content = catalogue.resource('file', '/etc/sysconfig/atd').send(:parameters)[:content]
    content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
      'OPTS=',
    ]
  end

  it { should contain_file('/etc/at.allow').with_ensure('absent') }

  it do
    should contain_file('/etc/at.deny').with({
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0600',
    })
  end

  it "should contain /etc/at.deny with no content" do
    content = catalogue.resource('file', '/etc/at.deny').send(:parameters)[:content]
    content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == []
  end

  context 'with atd_opts => foo' do
    let(:params) {{ :atd_opts => 'foo' }}

    it do
      content = catalogue.resource('file', '/etc/sysconfig/atd').send(:parameters)[:content]
      content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
        'OPTS=foo',
      ]
    end
  end

  context 'when at_allow => ["foo", "bar"]' do
    let(:params) {{ :at_allow => ["foo", "bar"] }}

    it do
      should contain_file('/etc/at.allow').with({
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0600',
      })
    end

    it "should contain /etc/at.allow with valid contents" do
      content = catalogue.resource('file', '/etc/at.allow').send(:parameters)[:content]
      content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == ["foo","bar"]
    end
  end

  context 'when at_deny => ["foo", "bar"]' do
    let(:params) {{ :at_deny => ["foo", "bar"] }}

    it "should contain /etc/at.deny with valid contents" do
      content = catalogue.resource('file', '/etc/at.deny').send(:parameters)[:content]
      content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == ["foo","bar"]
    end
  end
end