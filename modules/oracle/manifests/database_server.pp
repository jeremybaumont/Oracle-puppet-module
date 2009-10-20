class oracle::database_server {
    
    # required user and groups  
    include oracle::administrators

    # required packages 
    include oracle::database_server::system_packages

    # required directories
    $oracle_base_path = "/opt/applications/oracle"
    oracle_dir { 
       "oracle_base":
        path => $oracle_base_path,
        ensure => directory,
        owner => "oracle",
        group => "oinstall",
        before => [
                    File["oracle_home"],
                    File["oracle_major_version"],
                    File["oracle_version"]
                ],
        mode => 755 
    }

    oracle_dir {
        "oracle_major_version":
        path => "${oracle_base_path}/${oracle_major_version}",
        ensure => directory,
        owner => "oracle",
        group => "oinstall",
        require => File["oracle_base"],
        before => [
                    File["oracle_home"],
                    File["oracle_version"]
                ],
        mode => 755 
    }

    oracle_dir {
        "oracle_version":
        path => "${oracle_base_path}/${oracle_major_version}/${oracle_version}",
        ensure => directory,
        owner => "oracle",
        group => "oinstall",
        require => [
                    File["oracle_base"],
                    File["oracle_major_version"]
                ],
        before => File["oracle_home"] ,
        mode => 755 
    }

    oracle_dir { 
        "oracle_home":
        path => "${oracle_base_path}/${oracle_major_version}/${oracle_version}/${oracle_patch_version}",  
        ensure => directory,
        owner => "oracle",
        group => "oinstall",
        require => [
                    File["oracle_base"],
                    File["oracle_major_version"],
                    File["oracle_version"]
                ],
        mode => 755
    }
}

define oracle_dir ( $path, $ensure, $owner, $group, $mode ) {
    file {
        $name:
        path => $path,
        ensure => $ensure,
        force => true,
        owner => $owner,
        group => $group,
        recurse => 5,
        mode => $mode
    }
}



class oracle::database_server::system_packages {

    case $operatingsystem {
        "solaris": {
            $sun_provider = "sun"
            case $oracle_major_version {
                "10g": {
                    case $architecture {
                        "sparc64": {
                            $system_packages = ["SUNWarc", "SUNWbtool", "SUNWhea", "SUNWlibm", "SUNWlibms", "SUNWsprot", "SUNWtoo", "SUNWi1of", "SUNWi1cs", "SUNWi15cs", "SUNWxwfnt", "SUNWsprox"]
                        }
                        "sparc32": {
                            $system_packages = ["SUNWarc", "SUNWbtool", "SUNWhea", "SUNWlibm", "SUNWlibms", "SUNWsprot", "SUNWtoo", "SUNWi1of", "SUNWi1cs", "SUNWi15cs", "SUNWxwfnt"]
                        }
                        default: { 
                            fail("oracle::database_server - the architecture $architecture is not
                                yet supported by class system_packages.") 
                        }
                    }
                }
                "9i": {
                    case $architecture {
                        "sparc64": {
                            $system_packages = ["SUNWarc", "SUNWbtool", "SUNWhea", "SUNWlibm", "SUNWlibms", "SUNWsprot", "SUNWtoo", "SUNWi1of", "SUNWxwfnt"]
                         }
                        "sparc32": {
                            $system_packages = ["SUNWarc", "SUNWbtool", "SUNWhea", "SUNWlibm", "SUNWlibms", "SUNWsprot", "SUNWtoo", "SUNWi1of", "SUNWxwfnt"]
                        }

                        default: { 
                            fail("oracle::database_server - the architecture $architecture is not
                                yet supported by class system_packages.") 
                        }
                    }
                }

                default: { 
                        fail("oracle::database_server - the oracle version $oracle_major_version is not
                           yet support by class system_packages.") 
                    }
            }
        }
        default: {
            fail("oracle::database_server - the operating system $operatingsystem is not
                 yet supported by class system_packages.")
        } 
    
    }

    notify {"oracle::database_server - the operating system is ${operatingsystem}": }
    notify {"oracle::database_server - the architecture is ${architecture}": }
    notify {"oracle::database_server - the architecture is ${oracle_major_version}": }
    notify {"oracle::database_server - the list of packages required is ${system_packages}": }

    package { $ystem_packages: ensure => installed, provider => $sun_provider }

}
