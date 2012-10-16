# /etc/puppet/modules/cassandra/manifests/params.pp

class twissandra::params {
    $djangoip = $hostname ? {
        default => $ipaddress,
    }
} 
