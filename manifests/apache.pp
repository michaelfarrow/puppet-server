class server::apache {

	class { '::apache':
	  default_mods        => false,
	  default_vhost       => false,
	  default_confd_files => false,
	}

}
