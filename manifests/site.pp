define nginx::site($ensure=present,
                  $user  = false,
                  $group = false,
                  $mode  = 0755,
                  $server_name = $name,
                  $home        = '/var/www',
                  $create_root = true,
                  $port = 80,
                  $uwsgi = false,
                  $aliases = [],
                  $options = '',
                  $conf_source = 'nginx/site.conf.erb') {

  include nginx::params

  if $user {
    $_owner = $user
  } else {
    $_owner = 'root'
  }

  if $group {
    $_group = $group
  } else {
    $_group = $nginx::params::nginx_user
  }

  if $create_root {
    file {"${home}":
      ensure => $ensure? {present => directory, default => $ensure },
      owner  => $_owner,
      group  => $_group,
      mode   => $mode,
    }
    file {"${home}/htdocs":
      ensure => $ensure? {present => directory, default => $ensure },
      owner  => $_owner,
      group  => $_group,
      mode   => $mode,
    }
  }

  file {"/etc/nginx/sites-available/${name}.conf":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($conf_source),
    notify  => Exec['nginx-reload'],
  }

  file {"/etc/nginx/sites-enabled/${name}.conf":
    ensure => $ensure? { present => link, default => $ensure},
    target => "../sites-available/${name}.conf",
    notify => Exec['nginx-reload'],
  }
}
