class zookeeper_rest (
  $version              = $zookeeper_rest::params::version,

  $install_dir          = $zookeeper_rest::params::install_dir,
  $config_file          = $zookeeper_rest::params::config_file,
  $install_method       = $zookeeper_rest::params::install_method,
  $install_prefix       = $zookeeper_rest::params::install_prefix,
  $mirror_url           = $zookeeper_rest::params::mirror_url,
  $config               = {},
  $config_defaults      = $zookeeper_rest::params::config_defaults,
  $install_dependencies = $zookeeper_rest::params::install_dependencies,
  $install_python       = $zookeeper_rest::params::install_python,
  $install_java         = $zookeeper_rest::params::install_java,
  $install_maven        = $zookeeper_rest::params::install_maven,
  $package_dir          = $zookeeper_rest::params::package_dir,
  $service_install      = $zookeeper_rest::params::service_install,
  $service_ensure       = $zookeeper_rest::params::service_ensure,
  $service_restart      = $zookeeper_rest::params::service_restart,
  $package_name         = $zookeeper_rest::params::package_name,
  $package_ensure       = $zookeeper_rest::params::package_ensure,
  $group_id             = $zookeeper_rest::params::group_id,
  $user_id              = $zookeeper_rest::params::user_id,

  $config_dir      = $zookeeper_rest::params::params::config_dir,
  $custom_config   = {},
  $pid_location    = $zookeeper_rest::params::params::pid_location,
  $log_dir         = $zookeeper_rest::params::params::log_dir,

) inherits zookeeper_rest::params {

  validate_re($::osfamily, 'RedHat|Debian\b', "${::operatingsystem} not supported")

  validate_bool($install_dependencies)
  validate_bool($install_python)
  validate_bool($install_java)
  validate_bool($install_maven)

  validate_hash($custom_config)

  $basefilename = "zookeeper-${version}.tar.gz"
  $package_url  = "${mirror_url}/zookeeper-${version}/${basefilename}"

  $install_directory = $install_dir ? {
    $hue::params::install_dir => "/opt/zookeeper_rest-${version}",
    default                   => $install_dir,
  }

  group { 'zookeeper_rest':
    ensure => present,
    system => true,
    gid    => $group_id,
  }

  user { 'zookeeper_rest':
    ensure     => present,
    system     => true,
    groups     => 'zookeeper_rest',
    uid        => $user_id,
    shell      => '/sbin/nologin',
    require    => Group['zookeeper_rest'],
  }

  file { $package_dir:
    ensure  => directory,
    owner   => 'zookeeper_rest',
    group   => 'zookeeper_rest',
    require => [
      Group['zookeeper_rest'],
      User['zookeeper_rest'],
    ],
  }

  file { $install_directory:
    ensure  => directory,
    owner   => 'zookeeper_rest',
    group   => 'zookeeper_rest',
    require => [
      Group['zookeeper_rest'],
      User['zookeeper_rest'],
    ],
  }

  file { '/opt/zookeeper_rest':
    ensure  => link,
    target  => $install_directory,
    require => File[$install_directory],
  }

  file { '/var/log/zookeeper_rest':
    ensure  => directory,
    owner   => 'zookeeper_rest',
    group   => 'zookeeper_rest',
    require => [
      Group['zookeeper_rest'],
      User['zookeeper_rest'],
    ],
  }

  include '::archive'

  archive { "${package_dir}/${basefilename}":
    ensure          => present,
    extract         => true,
    extract_command => 'tar xfz %s --strip-components=1',
    extract_path    => $install_directory,
    source          => $package_url,
    creates         => "${install_directory}/Makefile",
    cleanup         => true,
    user            => 'zookeeper_rest',
    group           => 'zookeeper_rest',
    require         => [
      File[$package_dir],
      File[$install_directory],
      Group['hue'],
      User['hue'],
      ],
    }
}