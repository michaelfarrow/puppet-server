class server::apache (
	$mpm_module = undef
) {

	class { '::apache':
		default_mods        => false,
		default_vhost       => false,
		default_confd_files => false,
		mpm_module          => $mpm_module,
	} -> 

	file_line { 'Apache umask':
		path   => '/etc/apache2/envvars',
		line   => 'umask 002',
		notify => Service['httpd'],
	}

	include apache::mod::dir

}
