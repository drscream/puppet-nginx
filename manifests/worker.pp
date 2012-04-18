define nginx::worker ($config='nginx/worker.conf.erb', $server=[]) {
	include nginx::params

	file {
		"/etc/nginx/conf.d/worker-${name}.conf":
			ensure  => present,
			owner   => 'root',
			group   => 'root',
			content => template($config),
			notify  => Exec['nginx-reload'],
	}
}
