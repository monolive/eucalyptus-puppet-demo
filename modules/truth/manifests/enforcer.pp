class truth::enforcer {
    include ntp
    $groupname = "$company_cloud:$company_role"
    case $groupname {
        "Eucalyptus:Cassandra" : {
            include twissandra
        }
    }
    case $company_role {
        "Database" : {
        include postgresql-server
        }
    }
}
