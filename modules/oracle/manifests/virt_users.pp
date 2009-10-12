class virt_users  {

    @user { oracle:
        ensure  => present,
        uid     => 500,
        gid     => 500,
        comment => "Oracle User",
        home    => "/home/oracle",
        require => Group["dba"],
        shell   => "/bin/bash",
    }
}
