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
	$java_home = '/usr/lib/jvm/java-1.7.0-openjdk-amd64'
) {

  $package = "tomcat${version}"
  $user = "tomcat${version}"
  $group = "tomcat${version}"
  $dir = "/usr/share/tomcat${version}"
  $conf_dir = "/etc/tomcat${version}"
  $lib_dir = "${dir}/lib"
  $shared_dir = "/var/lib/tomcat${version}/shared"
  $webapps_dir = "/var/lib/tomcat${version}/webapps"
  $logs_dir = "/var/lib/tomcat${version}/logs"
  
  package {
  	'tomcat': name => $package, ensure => present;
  	'tomcat-admin': name => "${package}-admin", ensure => present;
  }
  exec { tomcat_java_home:
  	command => "sed -i -e '/JAVA_HOME/ c JAVA_HOME=\"${java_home}\"' /etc/default/tomcat6",
  	path => ['/bin', '/usr/bin'],
  	logoutput => true,
  	unless => "grep '${java_home}' /etc/default/tomcat6",
  	require => Package['tomcat'],
  	notify => Service['tomcat']
  }
  service { 'tomcat':
  	name => $package,
  	enable => true,
  	ensure => running,
  	hasstatus => true,
  	require => [ Package['tomcat'], Exec['tomcat_java_home'] ]
  }

}
