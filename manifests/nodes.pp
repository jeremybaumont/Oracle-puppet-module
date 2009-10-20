
node 'jeremy-test.wanadoo.nl' {
    $architecture = "sparc64"
    $oracle_major_version = "10g"
    $operatingsystem = "solaris"
    $oracle_version = "10.2.0.4"
    $oracle_patch_version = "earth"

    include  oracle::database_server 
    
}
