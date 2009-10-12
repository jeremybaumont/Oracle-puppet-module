
node basenode {
    case $operatingsystem {
        solaris: { include solaris }
        default: { include solaris }
    }
    include baseapps
}

node default inherits basenode{}

node oracle_database_server inherits basenode {
    include oracle_database_server, oracle_administrators
}
