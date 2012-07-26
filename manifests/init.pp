# Class: tomcat
#
# This module manages tomcat
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
# class { tomcat: version => 6 }
# [Remember: No empty lines between comments and class definition]
class tomcat (
	$version,
	$enable_service  = true
) {
  $package     = "tomcat${version}"
  $user        = "tomcat${version}"
  $group       = "tomcat${version}"
  $dir         = "/usr/share/tomcat${version}"
  $conf_dir    = "/etc/tomcat${version}"
  $lib_dir     = "${dir}/lib"
  $shared_dir  = "/var/lib/tomcat${version}/shared"
  $webapps_dir = "/var/lib/tomcat${version}/webapps"
  $logs_dir    = "/var/lib/tomcat${version}/logs"

  package {
  	'tomcat': name => $package, ensure => present;
  	'tomcat-admin': name => "${package}-admin", ensure => present;
  }
  service { tomcat:
  	name      => $package,
  	enable    => $enable_service,
  	ensure    => $enable_service ? { true => running, default => undef },
  	hasstatus => true,
  	require   => Package['tomcat'],
  }

}
