class baseapps {
    case $operatingsystem {

        solaris: {
            $packagelist = ["vim","perl", "rubygems"]
            $provider = "sunfreeware"
        }
        default: {
            fail ( "The operating system $operatingsystem
                    is not yet supported by baseapps class")
        }
    }

    package { 
        $packagelist: 
        ensure => installed,
        provider => $provider 
    }    

}
