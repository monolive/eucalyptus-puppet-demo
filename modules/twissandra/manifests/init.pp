class twissandra::install_rpm {
    $twissandra_package = ['git','gcc','python-devel','python-setuptools']
    package { $twissandra_package:
        ensure      => latest,
        require     => Class[Cassandra],
    }
}

class twissandra::install_prereq {
    Exec {
        path    => "/usr/bin",
    }
    exec { "install_pip":
        command => "/usr/bin/easy_install -U pip",
        require => Class["twissandra::install_rpm"],
    }
    exec { "install_distribute":
        command => "/usr/bin/easy_install -U distribute",
    }
    exec { "grab-twissandra":
        command => "/usr/bin/git clone http://github.com/twissandra/twissandra.git",
        cwd     => "/usr/local",
        creates => "/usr/local/twissandra",
    }
}

class twissandra::patch {
    file {"/usr/local/twissandra/requirements.txt":
        source  => "puppet:///modules/twissandra/requirements.txt",
        owner   => "root",
        group   => "root",
        mode    => 644,
        require => Class["twissandra::install_prereq"],
    }
}

class twissandra::install_twiss {
    exec { "install_twissandra":
        command => "pip install -U -r twissandra/requirements.txt",
        require => Class["twissandra::patch"],
        path    => "/usr/bin",
        cwd     => "/usr/local",
    }
}
 
class twissandra {
    include cassandra
    include twissandra::install_prereq, twissandra::install_twiss, twissandra::install_rpm, twissandra::patch
}


