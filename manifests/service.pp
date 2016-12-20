class zookeeper_rest::service (

  $service_install = $zookeeper_rest::service_install,
  $service_ensure  = $zookeeper_rest::service_ensure,
  $log4j_opts      = $zookeeper_rest::log4j_opts,
  $opts            = $zookeeper_rest::opts,
  $config_dir      = $zookeeper_rest::config_dir,
  $pid_location    = $zookeeper_rest::pid_location,
  $log_dir         = $zookeeper_rest::log_dir,
  $service_name    = $zookeeper_rest::params::service_name,

)
{

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $service_install {
    if $::service_provider == 'systemd' {
      include ::systemd
      file { "${service_name}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${service_name}.service",
        mode    => '0644',
        content => template('zookeeper_rest/unit.erb'),
      }
     file { "/etc/init.d/${service_name}":
        ensure => absent,
      }

      File["${service_name}.service"] ~>
      Exec['systemctl-daemon-reload'] ->
      Service[$service_name]
    } else {
      file { "${service_name}.service":
        ensure  => file,
        path    => "/etc/init.d/${service_name}",
        mode    => '0755',
        content => template('zookeeper_rest/init.erb'),
        before  => Service[$service_name],
      }
    }

    service { $service_name:
      ensure     => $service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    debug('Skipping service install')
  }

}
