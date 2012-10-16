# /etc/puppet/modules/cassandra/manifests/params.pp

class cassandra::params {
        $cluster_name = $hostname ? {
                default => "Cassandra Cluster",
        }
        if $company_seederip == 'yes' {
            $seeds = $hostname ? {
                default => $ipaddress,
            }
        }
        else {
            $seeds = $hostname ? {
                default => $company_seederip,
            }
        }       
} 


