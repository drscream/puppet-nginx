puppet-nginx module for limeade
===============================

It's a special puppet-nginx module for the cool limeade webinterface. It 
supports nginx deployment installation and proxy setup.

usage
-----

Include the module which will install nginx and deploy some default 
configs that are required.

<pre>
class foobar {
	include nginx
}
</pre>

Create a list of workers that are defined.

<pre>
$web_php_nodes_ip      = ["2a01:138:a015:4:216:3eff:fedb:5315", "172.22.175.88"]
$web_wsgi_nodes_ip     = ["172.22.175.88"]
$web_static_nodes_host = ["v4.doc.fruky.net"]

$web_lb_styles = {
  'static' => {'server' => $web_static_nodes_ip,},
  'php' => {'server' => $web_php_nodes_ip,},
  'wsgi' => {'server' => $web_wsgi_nodes_ip,},
}

create_resources(nginx::worker, $web_lb_styles)
</pre>

Create vhosts for each domain.

<pre>
$web_lb_vhosts = {
        'foo.frubar.net' => {
                'style'    => 'static',
                'cert_id'  => undef,
                'cert_ip'  => undef,
                'aliases'  => [],
        },

        'default.frubar.net' => {
                'style'    => 'php',
                'cert_id'  => undef,
                'cert_ip'  => undef,
                'aliases'  => ["*.frubar.net"],
        },

        'ssl.frubar.net' => {
                'style'    => 'php',
                'cert_id'  => "1",
                'cert_ip'  => "192.178.2.0",
                'aliases'  => [],
        },
}

create_resources(nginx::proxy, $web_lb_vhosts)
</pre>
