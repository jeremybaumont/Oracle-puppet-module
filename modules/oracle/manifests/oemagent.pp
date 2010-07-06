class oracle::oemagent {

    $oemagent_base_software = "/software/oracle/oem_agent"
    $oemagent_bin_install_path = "${oemagent_base_software}/${architecture}/"
    $tmp_dir = "/var/tmp"
    $orainst_loc_path = "/var/opt/oracle/oraInst.loc"
    $oemagent_dest_install_path = "/opt/app/oracle/product"
    $orainventory_path = "/opt/app/oracle/oraInventory"

    case $architecture {
        default: {
            err("unknown architecture value ${architecture} or not yet implemented") 
        } # end of default
        sparc32,sparc64: {

            $agentDownload_filename = "agentDownload.solaris"

            file{
                "wagentDownload-10204-sparc":
                    name => "${tmp_dir}/wagentDownload-10204.sh",
                    content => template("oracle/wagentDownload-template.erb"),
                    mode => 755,
                    owner => "oracle",
                    group => "oinstall",
                    require => File["/var/opt/oracle/oracle_db_server_soft_installed"],
            }

            exec {
                "run_wagentDownload-10204-sparc":
                    command => "wagentDownload-10204.sh > ${tmp_dir}/run_wagentDownload-10204-sparc.log",
                    path => ["/users/oracle/bin","/usr/bin", "/usr/sbin", ".", "/opt/csw/bin", "/usr/sbin", "/usr/bin", "/usr/dt/bin", 
                                            "/usr/openwin/bin", "/usr/ccs/bin",  "/usr/sfw/bin", "/usr/perl5/5.8.4/bin", "/opt/SUNWspro/bin"],
                    cwd => "${tmp_dir}",
                    creates => "/var/opt/oracle/oemagent_installed",
                    group => "oinstall",
                    user => "oracle",
                    logoutput => true,
                    returns => [0,1],
                    require => File["wagentDownload-10204-sparc"],
                    timeout => "-1",
            }
            
        } # end of sparc32,sparc64
        x86-64: {

            $agentDownload_filename = "agentDownload.solaris_x64"

            file{
                "wagentDownload-10205-x86-64":
                    name => "${tmp_dir}/wagentDownload-10205.sh",
                    content => template("oracle/wagentDownload-template.erb"),
                    mode => 755,
                    owner => "oracle",
                    group => "oinstall",
                    require => File["/var/opt/oracle/oracle_db_server_soft_installed"],
            }

    
            exec {
                "run_wagentDownload-10205-x86-64":
                    command => "wagentDownload-10205.sh > ${tmp_dir}/run_wagentDownload-10205-x86-64.log",
                    path => ["/users/oracle/bin","/usr/bin", "/usr/sbin", ".", "/opt/csw/bin", "/usr/sbin", "/usr/bin", "/usr/dt/bin", 
                                            "/usr/openwin/bin", "/usr/ccs/bin",  "/usr/sfw/bin", "/usr/perl5/5.8.4/bin", "/opt/SUNWspro/bin"],
                    cwd => "${tmp_dir}",
                    creates => "/var/opt/oracle/oemagent_installed",
                    group => "oinstall",
                    user => "oracle",
                    logoutput => true,
                    returns => [0,1],
                    require => File["wagentDownload-10205-x86-64"],
                    timeout => "-1",
            }

        } # end of x86-64    


    } # end of case

} # end of class
