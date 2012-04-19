class nginx {
  include nginx::params

  package { 'nginx':
    name => 'nginx-light',
    ensure => installed,
  }

  service { 'nginx':
    ensure => running,
    enable => true,
    require => Package['nginx'],
  }

  exec {"nginx-reload":
    refreshonly => true,
    command     => "nginx -s reload",
    onlyif      => "nginx -t",
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
