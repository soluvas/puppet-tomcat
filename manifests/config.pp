# Class: tomcat
#
# This module manages simple tomcat config in /etc/default/tomcat{6,7}
#
# Note: If you add other environment variables, it's better to configure Tomcat yourself
# without this class, e.g. :
#
# Nexus
# PLEXUS_NEXUS_WORK=/var/lib/nexus
#
# # Jenkins
# JENKINS_HOME=/home/jenkins/.jenkins
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
# class { tomcat::config:
#	$java_home => '/usr/lib/jvm/java-7-openjdk-amd64',
#	$java_opts => '-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC',
# }
# [Remember: No empty lines between comments and class definition]
class tomcat::config (
	$java_home, #      = '/usr/lib/jvm/java-7-openjdk-amd64',
	$java_opts   = '-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC'
) {
  file { "/etc/default/tomcat${tomcat::version}":
  	mode    => 0644,
  	content => template('tomcat/default.erb'),
  	require => Class['tomcat'],
  }
}
