class baseapps {

        $packagelist = ["vi","perl", "rubygems"]

        package { $packagelist: 
            ensure => installed }    

}
