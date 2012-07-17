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
	$java_home = '/usr/lib/jvm/java-1.7.0-openjdk-amd64',
	$catalina_opts = '-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC',
	$enable_service = true
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
  # Note: Tried augeas, but it didn't work with space-separated values
  # like JAVA_OPTS :-( should file a bug there
  exec { tomcat_java_opts:
  	command => "sed -i -e '/^#\\?JAVA_OPTS=/ c JAVA_OPTS=\"${catalina_opts}\"' /etc/default/tomcat${version}",
  	path => ['/bin', '/usr/bin'],
  	logoutput => true,
  	unless => "grep '^JAVA_OPTS=\"${catalina_opts}\"' /etc/default/tomcat${version}",
  	require => Package['tomcat'],
  	notify => Service['tomcat']
  }
  exec { tomcat_java_home:
  	command => "sed -i -e '/^#\\?JAVA_HOME=/ c JAVA_HOME=\"${java_home}\"' /etc/default/tomcat${version}",
  	path => ['/bin', '/usr/bin'],
  	logoutput => true,
  	unless => "grep '^JAVA_HOME=\"${java_home}\"' /etc/default/tomcat${version}",
  	require => Package['tomcat'],
  	notify => Service['tomcat']
  }
  service { tomcat:
  	name => $package,
  	enable => $enable_service,
  	ensure => $enable_service ? { true => running, default => undef },
  	hasstatus => true,
  	require => [ Package['tomcat'], Exec['tomcat_java_opts'], Exec['tomcat_java_home'] ]
  }

}
