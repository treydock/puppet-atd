# == Class: atd
#
class atd (
  $atd_opts                 = $atd::params::atd_opts,
  $package_name             = $atd::params::package_name,
  $service_ensure           = 'running',
  $service_enable           = true,
  $service_config_path      = $atd::params::service_config_path,
  $service_config_template  = $atd::params::service_config_template,
  $service_name             = $atd::params::service_name,
  $service_hasstatus        = $atd::params::service_hasstatus,
  $service_hasrestart       = $atd::params::service_hasrestart,
  $at_allow                 = [],
  $at_deny                  = [],
  $at_allow_template        = $atd::params::at_allow_template,
  $at_deny_template         = $atd::params::at_deny_template,
) inherits atd::params {

  validate_array($at_allow)
  validate_array($at_deny)

  package { 'at':
    ensure  => 'present',
    name    => $package_name,
    before  => File['/etc/sysconfig/atd'],
  }

  service { 'atd':
    ensure      => $service_ensure,
    enable      => $service_enable,
    name        => $service_name,
    hasstatus   => $service_hasstatus,
    hasrestart  => $service_hasrestart,
    subscribe   => File['/etc/sysconfig/atd'],
  }

  file { '/etc/sysconfig/atd':
    ensure    => 'file',
    path      => $service_config_path,
    content   => template($service_config_template),
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
  }

  if empty($at_allow) {
    file { '/etc/at.allow':
      ensure  => 'absent',
    }
  } else {
    file { '/etc/at.allow':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => template($at_allow_template),
    }
  }

  file { '/etc/at.deny':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template($at_deny_template),
  }

}
