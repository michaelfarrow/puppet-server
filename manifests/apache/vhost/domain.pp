class server::apache::vhost::domain inherits server::apache::vhost::base {

	include apache::mod::vhost_alias

	$virtual_docroot = '/var/www/vhosts/%0/current/public'

	Concat::Fragment <| title == "${fqdn}-docroot" |> {
		docroot => '/var/www',
		content => template('server/vhost/_docroot.erb'),
	}

}
