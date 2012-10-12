class httpd::install {
    $php_packages = ['httpd']
    package { $php_packages:
        ensure  => latest,
    } 
}
 
class httpd::config {
    File{
        require => Class["httpd::install"],
        notify  => Class["httpd::service"],
        owner   => "root",
        group   => "root",
        mode    => 644
    }
 
    file{"/etc/httpd/conf/httpd.conf":
        source => "puppet:///modules/httpd/httpd.conf";
    }
}

class httpd::service {
    service{"httpd":
        ensure  => running,
        enable  => true,
        require => Class["httpd::config"],
    }
}
 
class httpd {
    include httpd::install, httpd::config, httpd::service
}
