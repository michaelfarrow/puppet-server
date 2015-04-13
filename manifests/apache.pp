class server::apache (
	$mpm_module = undef
) {

	class { '::apache':
	  default_mods        => false,
	  default_vhost       => false,
	  default_confd_files => false,
	  mpm_module          => $mpm_module,
	}

	include apache::mod::dir

}
