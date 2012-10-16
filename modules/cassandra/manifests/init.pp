class cassandra::repo {
    yumrepo{"cassandra":
        baseurl     => "http://rpm.riptano.com/community/",
        descr       => "DataStax RPM Repository",
        enabled     => 1,
        gpgcheck    => 0,
    }
}
 
class cassandra::install {
    $cassandra_package = ['apache-cassandra11','python26-thrift']
    package { $cassandra_package:
        ensure  => latest,
        require => Class["cassandra::repo"],
    }
    file{"/etc/init.d/cassandra":
        source  => "puppet:///modules/cassandra/cassandra",
        owner   => "root",
        group   => "root",
        mode    => 755,
        require => Package["apache-cassandra11"],
    }
}

 
class cassandra::config {
    File{
        require => Class["cassandra::install"],
        owner   => "cassandra",
        group   => "cassandra",
        mode    => 755,
    }
    file{"/etc/cassandra/conf/cassandra-env.sh":
        source  => "puppet:///modules/cassandra/cassandra-env.sh",
        notify  => Class["cassandra::service"],
    }
    file{"/lib/jamm-0.2.5.jar":
        ensure  => 'link',
        target  => '/usr/share/cassandra/lib/jamm-0.2.5.jar',
    }
}

class cassandra::cassandra_yaml {
        file { "/etc/cassandra/conf/cassandra.yaml":
                content => template("cassandra/cassandra.yaml.erb"),
                owner   => "cassandra",
                group   => "cassandra",
                mode    => "644",
                require => Class["cassandra::config"],
                notify  => Class["cassandra::service"],
        }
}
        
class cassandra::service {
    service{"cassandra":
        ensure  => running,
        enable  => true,
        require => Class["cassandra::cassandra_yaml"],
        hasrestart  => true,
    }
}

class cassandra {
    require cassandra::params
    include cassandra::repo, cassandra::install, cassandra::service, cassandra::config, cassandra::cassandra_yaml
}

