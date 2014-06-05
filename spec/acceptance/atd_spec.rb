require 'spec_helper_acceptance'

describe 'atd class:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
        class { 'atd': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  describe package('at') do
    it { should be_installed }
  end

  describe service('atd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/sysconfig/atd') do
    its(:content) { should match /^OPTS=$/ }
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/at.allow') do
    it { should_not be_file }
  end

  describe file('/etc/at.deny') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  context "with at_allow" do
    it "should run successfully" do
      pp =<<-EOS
        class { 'atd': at_allow => ['root'] }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/at.allow') do
      its(:content) { should match /^root$/ }
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end
  end

  context "with default parameters" do
    it "should run successfully" do
      pp =<<-EOS
        class { 'atd': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/at.allow') do
      it { should_not be_file }
    end
  end
end
