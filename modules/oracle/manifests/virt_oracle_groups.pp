class virt_oracle_groups inherits virt_groups {

    @group { dba:
        gid    => 200,
        ensure => present,
    } 

    @group { oinstall:
        gid    => 201,
        ensure => present,
    } 
}
