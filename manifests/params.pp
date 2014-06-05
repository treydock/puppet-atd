# == Class: atd::params
#
# The atd configuration settings.
#
class atd::params {

  case $::osfamily {
    'RedHat': {
      $package_name             = 'at'
      $service_name             = 'atd'
      $service_hasstatus        = true
      $service_hasrestart       = true
      $service_config_path      = '/etc/sysconfig/atd'
      $service_config_template  = 'atd/atd.sysconfig.erb'
      $at_allow_template        = 'atd/at.allow.erb'
      $at_deny_template         = 'atd/at.deny.erb'
      $atd_opts                 = ''
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
