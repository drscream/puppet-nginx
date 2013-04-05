class nginx {
  include nginx::params

  $nginx_user = $nginx::params::nginx_user

  package { 'nginx':
    name => 'nginx-full',
    ensure => present,
  }

  service { 'nginx':
#    ensure => running,
#    enable => true,
    require => Package['nginx'],
  }

  exec {"nginx-reload":
    refreshonly => true,
    command     => "nginx -s reload",
    onlyif      => "nginx -t",
  }

  file { "/etc/nginx/nginx.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nginx/nginx.conf.erb'),
    notify  => Exec['nginx-reload'],
  }

  file { "/etc/nginx/microcaching_params":
    ensure  => present,
    require => Package['nginx'],
    notify  => Service['nginx'],
    source  => 'puppet:///modules/nginx/etc/nginx/microcaching_params',
    purge   => true,
    force   => true,
    recurse => true,
  }

  file { ["/etc/nginx/sites-available", "/etc/nginx/sites-enabled", "/etc/nginx/conf.d"]:
    ensure  => directory,
    require => Package['nginx'],
    notify  => Service['nginx'],
    source  => 'puppet:///modules/nginx/empty',
    purge   => true,
    force   => true,
    recurse => true,
  }

  file{ "/etc/nginx/conf.d/proxy.conf":
    ensure  => present,
    require => Package['nginx'],
    notify  => Service['nginx'],
    source  => 'puppet:///modules/nginx/etc/nginx/conf.d/proxy.conf',
    purge   => true,
    force   => true,
    recurse => true,
  }
}
