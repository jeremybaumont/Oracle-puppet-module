class virt_oracle_users inherits virt_users {

    @user { oracle:
        ensure  => present,
        uid     => 200,
        gid     => 200,
        comment => "Oracle User",
        home    => "/home/oracle",
        require => Group["dba"],
        shell   => "/bin/bash",
    }
}
