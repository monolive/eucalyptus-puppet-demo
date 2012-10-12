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
        ensure      => latest,
        require     => Class["cassandra::repo"],
    }
}
 
class cassandra::config {
    File{
        require => Class["cassandra::install"],
        notify  => Class["cassandra::service"],
        owner   => "cassandra",
        group   => "cassandra",
        mode    => 755
    }
 
    file{"/etc/cassandra/conf/cassandra-env.sh":
        source  => "puppet:///modules/cassandra/cassandra-env.sh";
 
    }
    file{"/lib/jamm-0.2.5.jar":
        ensure  => 'link',
        target  => '/usr/share/cassandra/lib/jamm-0.2.5.jar',
    }
}
 
class cassandra::service {
    service{"cassandra":
        ensure  => running,
        enable  => true,
        require => Class["cassandra::config"],
    }
}

class cassandra {
    include cassandra::repo, cassandra::install, cassandra::service, cassandra::config
}

