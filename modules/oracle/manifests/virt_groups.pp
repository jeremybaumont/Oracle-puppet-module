class oracle::virt_groups  {

    @group { dba:
        gid    => 500,
        ensure => present,
    } 

    @group { oinstall:
        gid    => 501,
        ensure => present,
    } 
}
