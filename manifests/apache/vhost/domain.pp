class server::apache::vhost::domain (
	$docroot = '/var/www/'
) inherits server::apache::vhost::base {

	include apache::mod::vhost_alias

	$virtual_docroot = '/var/www/vhosts/%0/current/public'

	Concat::Fragment <| title == "${fqdn}-docroot" |> {
		content => template('server/vhost/_docroot.erb'),
	}

}
