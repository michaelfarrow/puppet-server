class server::apache::vhost::base (
	$docroot = '/var/www/vhosts/default'
) {

	apache::vhost { "${fqdn}":
		servername  => "${fqdn}",
		docroot     => $docroot,
		port        => '80',
		directoryindex => 'index.html index.php',
		override    => 'All',
		rewrites    => [
			{
				comment      => 'Rewrite www to non www',
				rewrite_cond => ['%{HTTP_HOST} ^www\.(.*)$ [NC]'],
				rewrite_rule => ['^(.*)$ http://%1/$1 [R=301,L]'],
			},
		],
		setenvif    => [
			'X-Forwarded-For "^$" direct',
			'X-Forwarded-For "^.*\..*\..*\..*" forwarded',
		],
		access_logs => [
			{
				file    => 'access.log',
				format  => '[D] %V %h %t \"%r\" %>s %b \"%{User-Agent}i\"',
				env     => 'direct',
			},
			{
				file    => 'access.log',
				format  => '[P] %V %{X-Forwarded-For}i %t \"%r\" %>s %b \"%{User-Agent}i\"',
				env     => 'forwarded',
			},
		],
		notify      => Service['httpd'],
	}
}
