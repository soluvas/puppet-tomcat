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
	$version
) {

  $package = "tomcat${version}"
  
  package {
  	'tomcat': name => $package, ensure => present;
  	'tomcat-admin': name => "${package}-admin", ensure => present;
  }
  service { 'tomcat':
  	name => $package,
  	enable => true,
  	ensure => running,
  	hasstatus => true,
  	require => Package['tomcat']
  }

}
