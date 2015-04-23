class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
}->
class { 'postgresql::server': }

# PostgreSQL setup based on DSpace documentation
# https://wiki.duraspace.org/display/DSDOC5x/Installing+DSpace
postgresql::server::db { 'dspace':
    user     => 'dspace',
    password => postgresql_password('dspace', 'dspace'),
    encoding => 'UNICODE',
}
postgresql::server::pg_hba_rule { 'dspace access':
    type        => 'host',
    database    => 'dspace',
    user        => 'dspace',
    address     => '127.0.0.1/32',
    auth_method => 'md5',
    order       => '001',
}

file { "/etc/environment":
    content => inline_template("JAVA_HOME=/apps/jdk1.7.0_75")
}

# by default the CentOS 6.6 iptables config has
# all ports closed except for SSH (22)
firewall { '100 allow http and https access':
    port   => [80, 443, 8080, 8443],
    proto  => tcp,
    action => accept,
}
