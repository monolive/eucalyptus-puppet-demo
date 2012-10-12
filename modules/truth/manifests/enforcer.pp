class truth::enforcer {
    include ntp
    $groupname = "$company_platform:$company_role"
    case $groupname {
        "Eucalyptus:Twissandra" : {
            include twissandra 
        }
    }
    case $company_role {
        "Database" : {
        include postgresql-server
        }
    }
}
