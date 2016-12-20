class zookeeper_rest::params {

  $version         = '3.4.9'
  $install_method  = 'bin'
  $install_dir     = "/opt/zookeeper_rest-${version}"
#  $install_prefix  = '/usr/local'
  $mirror_url      = "http://ftp.cixug.es/apache/zookeeper"
  $install_python  = true
  $install_java    = true
  $install_maven   = true
  $install_dependencies = true
  $package_dir     = '/var/tmp/zookeeper'
  $package_name    = undef
  $package_ensure  = 'present'
  $group_id        = undef
  $user_id         = undef

#  $config_dir      = '/usr/local/hue/desktop/conf'
#  $config_file     = "${config_dir}/hue.ini"
#  $pid_location    = '/usr/local/hue/hue.pid'
#  $log_dir         = '/var/log/hue'

  $packages_dependencies = [ 'ant', 'asciidoc', 'cyrus-sasl-devel', 'cyrus-sasl-gssapi', 'cyrus-sasl-plain', 'gcc', 'gcc-c++', 'krb5-devel', 'rsync',
                             'libffi-devel', 'libxml2-devel', 'libxslt-devel', 'make', 'openldap-devel', 'sqlite-devel', 'openssl-devel', 'gmp-devel', 'mysql-devel', 'mysql' ]


  $service_name    = 'zookeeper_rest'
  $service_install = true
  $service_ensure  = 'running'

  $service_restart = true

}