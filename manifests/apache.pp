class server::apache (
	$mpm_module = undef
) {

	class { '::apache':
		default_mods        => false,
		default_vhost       => false,
		default_confd_files => false,
		mpm_module          => $mpm_module,
	}

	file_line { 'Apache umask':
		path    => '/etc/apache2/envvars',
		line    => 'umask 002',
		notify  => Service['httpd'],
		require => Package['httpd'],
	}

	file { '/var/www/cron':
		ensure => present,
		source => 'puppet:///modules/server/cron',
		owner  => $::apache::params::user,
		group  => $::apache::params::group,
	} ->

	cron { 'vhost cron minutely':
		command => "/var/www/cron minutely",
		user    => $::apache::params::user,
		minute  => '*',
	} ->

	cron { 'vhost cron hourly':
		command => "/var/www/cron hourly",
		user    => $::apache::params::user,
		minute  => 1,
	} ->

	cron { 'vhost cron daily':
		command => "/var/www/cron daily",
		user    => $::apache::params::user,
		minute  => 2,
		hour    => 4,
	} ->

	cron { 'vhost cron weekly':
		command => "/var/www/cron weekly",
		user    => $::apache::params::user,
		minute  => 22,
		hour    => 4,
		weekday => 0,
	} ->

	cron { 'vhost cron monthly':
		command => "/var/www/cron monthly",
		user    => $::apache::params::user,
		minute  => 24,
		hour    => 4,
		day     => 1,
	}

	include apache::mod::dir

}
