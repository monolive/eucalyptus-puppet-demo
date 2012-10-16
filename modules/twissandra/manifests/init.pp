class twissandra::install_rpm {
    $twissandra_package = ['git','gcc','python-devel','python-setuptools']
    package { $twissandra_package:
        ensure      => latest,
        require     => Class[Cassandra],
    }
    exec { "install_pip":
        command => "/usr/bin/easy_install -U pip",
        require => package["python-setuptools"],
        onlyif  => "test ! -f /usr/bin/pip",
        path    => "/usr/bin",
        }
    exec { "install_distribute":
        command => "/usr/bin/easy_install -U distribute",
        require => package["python-setuptools"],
#        onlyif  => "test ! -d /usr/lib/python2.6/site-packages/distribute-0.6.10-py2.6.egg-info",
        path    => "/usr/bin",
    }
}

class twissandra::grab_twiss {
    exec { "grab-twissandra":
        path    => "/usr/bin",
        command => "/usr/bin/git clone http://github.com/twissandra/twissandra.git",
        cwd     => "/usr/local",
        creates => "/usr/local/twissandra",
    }
}


class twissandra::install_twiss {
    require twissandra::install_rpm
    package { "django":
        provider    => pip,
        ensure      => "1.3.3",
    }
    package { "simplejson":
        provider    => pip,
    }
    package { "thrift":
        provider    => pip,
    }
    package { "pycassa":
        provider    => pip,
    }
}


class twissandra::config {
    require twissandra::install_twiss
    file { "/usr/local/twissandra/cass.py":
        content => template("twissandra/cass.py.erb"),
        owner   => "root",
        group   => "root",
        mode    => "644",
#        require => Class["twissandra::install_twiss"],
    }
    file { "/usr/local/twissandra/tweets/management/commands/sync_cassandra.py":
        content => template("twissandra/sync_cassandra.py.erb"),
        owner   => "root",
        group   => "root",
        mode    => "644",
#        require => Class["twissandra::install_twiss"],
    }
}

class twissandra::run {
    if $company_seederip == 'Yes' {
        exec {"populate_twissandra":
            command =>  "/usr/bin/python /usr/local/twissandra/manage.py sync_cassandra",
            path    => "/usr/bin",
            require => Class["twissandra::config"],
            before  => Exec["start_twissandra"],
        }
    }

    exec { "start_twissandra":
        command =>  "/usr/bin/python /usr/local/twissandra/manage.py  runserver 0.0.0.0:8000  > /dev/null 2>&1 &",
        path    => "/usr/bin",
        require => Class["twissandra::config"],
    }
}
 
class twissandra {
    require twissandra::params
    include twissandra::grab_twiss, twissandra::install_twiss, twissandra::install_rpm, twissandra::config, twissandra::run, cassandra
    Class['twissandra::install_rpm'] -> Class['twissandra::grab_twiss'] -> Class['twissandra::install_twiss'] -> Class['twissandra::config'] -> Class['twissandra::run']
}


