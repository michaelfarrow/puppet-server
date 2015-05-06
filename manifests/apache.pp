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

	file { '/etc/www_crong':
		ensure => present,
		source => 'puppet:///modules/server/cron',
		mode   => '0777'
	} ->

	cron { 'vhost cron minutely':
		command => "/etc/www_cron minutely",
		user    => $::apache::params::user,
		minute  => '*',
	} ->

	cron { 'vhost cron hourly':
		command => "/etc/www_cron hourly",
		user    => $::apache::params::user,
		minute  => 1,
	} ->

	cron { 'vhost cron daily':
		command => "/etc/www_cron daily",
		user    => $::apache::params::user,
		minute  => 2,
		hour    => 4,
	} ->

	cron { 'vhost cron weekly':
		command => "/etc/www_cron weekly",
		user    => $::apache::params::user,
		minute  => 22,
		hour    => 4,
		weekday => 0,
	} ->

	cron { 'vhost cron monthly':
		command  => "/etc/www_cron monthly",
		user     => $::apache::params::user,
		minute   => 24,
		hour     => 4,
		monthday => 1,
	}

	include apache::mod::dir

}
