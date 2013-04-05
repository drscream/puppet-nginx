define nginx::proxy(
	$ip='::',
	$server_port=80,
	$upstream=true,
	$style,
	$cert_id='',
	$cert_ip='',
	$aliases=[],
	$default=false,
	$config='nginx/proxy.conf.erb',
) {
	include nginx::params

	file {
		"/etc/nginx/sites-available/${name}.conf":
			ensure  => present,
			owner   => 'root',
			group   => 'root',
			mode    => 0644,
			content => template($config),
			notify  => Exec['nginx-reload'],	
	}

	file {"/etc/nginx/sites-enabled/${name}.conf":
		ensure => link,
		target => "../sites-available/${name}.conf",
		notify => Exec['nginx-reload'],
	}

}
