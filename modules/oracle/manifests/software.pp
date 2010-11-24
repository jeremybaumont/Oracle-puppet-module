#    software.pp - oracle database server software 9i/10g
#
#    Copyright (C) 2009 Jeremy Baumont 
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

###
### software class is responsible to silent install from a response file
### database server enterprise software only
###
class oracle::software {

    # You need the software cd/dvd/disks from Oracle downloaded
    # somewhere on the local machine
    $oracle_base_software = "/software/oracle/database_server"

    define install_oracle_database_server_software($oracle_version) {
        case $operatingsystem {
            default: { err ("unknown operation system value ${operatingsystem}") }
            solaris: {
                        case $oracle_version {
                            default: {err("unknown oracle version value ${oracle_version} or not yet implemented") }
                            "9.2.0.8": {
                                $disk1_9201_path = "${oracle_base_software}/${architecture}/9.2.0.1/disk1" 
                                $disk2_9201_path = "${oracle_base_software}/${architecture}/9.2.0.1/disk2" 
                                $disk3_9201_path = "${oracle_base_software}/${architecture}/9.2.0.1/disk3" 
                                $current_oracle_home = $oracle::directories::oracle_home_path
                                $responsefile_path = "${disk1_9201_path}/response/enterprise.rsp"
                                $current_oracle_base = $oracle::directories::oracle_base_path
                                $orainventory_path = "$current_oracle_base/oraInventory"
                                $tmp_dir = "/var/tmp"


                                # start an x server, required for the
                                # oracle installer
                                exec {
                                    "9208_start_vfb":
                                    command => "start_vfb.sh",
                                    path => ["/users/oracle/bin","/usr/bin", "/usr/sbin", ".", "/opt/csw/bin", "/usr/sbin", "/usr/bin", "/usr/dt/bin", 
                                            "/usr/openwin/bin", "/usr/ccs/bin",  "/usr/sfw/bin", "/usr/perl5/5.8.4/bin", "/opt/SUNWspro/bin"],
                                    cwd => "/users/oracle/bin",
                                    group => "root",
                                    user => "root",
                                    creates => "/var/opt/oracle/started_vfb",
                                    environment => ["DISPLAY=:0.0", "MAILTO=DL-ito.bs.dba@is.online.nl"],
                                    logoutput => true,
                                    returns => [0,1],
                                    require => [ 
                                        File["/users/oracle/bin/"],
                                        File["/users/oracle/bin/start_vfb.sh"]
                                    ],
                                    timeout => "-1",
                                }

                                # build a script to run silent installer
                                # of 9.2.0.1 Disk 1 Oracle database
                                # server software enterprise edition
                                file{
                                    "wruninstaller_9.2.0.1.sh":
                                    name => "${tmp_dir}/wruninstaller_9.2.0.1.sh",
                                    content => template("oracle/wruninstaller_9.2.0.1-template.erb"),
                                    mode => 755,
                                    owner => "oracle",
                                    group => "oinstall", 
                                } 

                                # build a wrapper script 
                                file{
                                    "wrapper_9.2.0.1.sh":
                                    name => "${tmp_dir}/wrapper_9.2.0.1.sh",
                                    content => template("oracle/wrapper_9.2.0.1-template.erb"),
                                    mode => 755,
                                    owner => "oracle",
                                } 

                                
                                # run silent installer of 9.2.0.1 Disk 1
                                # Orable database server software
                                # enterprise edition
                                exec {
                                    "runinstaller-oui-9201":
                                    command => "wrapper_9.2.0.1.sh > ${tmp_dir}/runinstaller-oui_9.2.0.1.log",
                                    path => ["/usr/bin", "/usr/sbin", ".", "/opt/csw/bin", "/usr/sbin", "/usr/bin", 
                                            "/usr/dt/bin", "/usr/openwin/bin", "/usr/ccs/bin",  "/usr/sfw/bin", "/usr/perl5/5.8.4/bin", "/opt/SUNWspro/bin"],
                                    cwd => "${tmp_dir}",
                                    creates => "/var/opt/oracle/9.2.0.1_installed",
                                    environment => ["DISPLAY=:0.0", "MAILTO=DL-ito.bs.dba@is.online.nl"],
                                    logoutput => true,
                                    returns => [0,1],
                                    require => [ 
                                        File ["wrapper_9.2.0.1.sh"],
                                        File ["wruninstaller_9.2.0.1.sh"],
                                        Exec ["9208_start_vfb"],
                                        File["var_opt_oracle"],
                                        File["oracle_home"],
                                        File["oracle_base"],
                                        File["/users/oracle/.bash_profile"],
                                        File["/var/opt/oracle/oraInst.loc"],
                                        File["/users/oracle/.bashrc"],
                                        File["/users/oracle"],
                                        User["oracle"],
                                        Group["dba"],
                                        Group["oinstall"]
                                        ],
                                    timeout => "-1",
                                }

                                # before installing the 9.2.0.8 patchset
                                # we need to shutdown all processes
                                # using the oracle home directories
                                file {
                                    "9208_stop_oracle_home_proc.sh":
                                    name => "${tmp_dir}/stop_oracle_home_proc.sh",
                                    content => template("oracle/stop_oracle_home_proc.erb"),
                                    mode => 755,
                                    owner =>"oracle",
                                    group => "oinstall", 

                                }
    
                                exec {
                                    "9208_stop_oracle_home_proc":
                                    command => "stop_oracle_home_proc.sh > ${tmp_dir}/stop_oracle_home_proc.log",
                                    path => ["/usr/bin", 
                                            "/usr/sbin", 
                                            ".", 
                                            "/opt/csw/bin", 
                                            "/usr/sbin", 
                                            "/usr/bin", 
                                            "/usr/dt/bin", 
                                            "/usr/openwin/bin", 
                                            "/usr/ccs/bin",  
                                            "/usr/sfw/bin",
                                            "/usr/perl5/5.8.4/bin", 
                                            "/opt/SUNWspro/bin"],
                                    cwd => "${tmp_dir}",
                                    group => "dba",
                                    user => "oracle",
                                    environment => ["DISPLAY=:0.0", "MAILTO=DL-ito.bs.dba@is.online.nl"],
                                    logoutput => true,
                                    returns => [0,1],
                                    require => [
                                        Exec ["runinstaller-oui-9201"],
                                        File ["9208_stop_oracle_home_proc.sh"],
                                        File["var_opt_oracle"],
                                        File["oracle_home"],
                                        File["oracle_base"],
                                        File["/users/oracle/.bash_profile"],
                                        File["/var/opt/oracle/oraInst.loc"],
                                        File["/users/oracle/.bashrc"],
                                        File["/users/oracle"],
                                        User["oracle"],
                                        Group["dba"],
                                        Group["oinstall"]
                                                ],
                                    timeout => "-1",
                                    
                                }
                                
                                
                                $disk1_9208_patchset_path = "${oracle_base_software}/${architecture}/patchset_9.2.0.8/Disk1" 
                                $responsefile_patchset_path = "${disk1_9208_patchset_path}/response/patchset.rsp"
                                $products_patchset_path = "${disk1_9208_patchset_path}/stage/products.xml"

                                # build a script to run silent installer
                                # of 9.2.0.8 Disk 1 Oracle database
                                # server software enterprise edition
                                # patchset
                                file{
                                    "wruninstaller_9.2.0.8_patchset.sh":
                                    name => "${tmp_dir}/wruninstaller_9.2.0.8_patchset.sh",
                                    content => template("oracle/wruninstaller_9.2.0.8_patchset-template.erb"),
                                    mode => 755,
                                    owner => "oracle",
                                    group => "oinstall", 
                                } 

                                # build a wrapper script 
                                file{
                                    "wrapper_9.2.0.8.sh":
                                    name => "${tmp_dir}/wrapper_9.2.0.8.sh",
                                    content => template("oracle/wrapper_9.2.0.8-template.erb"),
                                    mode => 755,
                                    owner => "oracle",
                                } 
                                
                                # run silent installer of 9.2.0.8 Disk 1
                                # Orable database server software
                                # enterprise edition patchset
                                exec {
                                    "runinstaller-patchset-oui-9208":
                                    command => 
                                "wrapper_9.2.0.8.sh > ${tmp_dir}/runinstaller-patchset-oui_9.2.0.8.log",
                                    path => ["/usr/bin", 
                                            "/usr/sbin", 
                                            ".", 
                                            "/opt/csw/bin", 
                                            "/usr/sbin", 
                                            "/usr/bin", 
                                            "/usr/dt/bin", 
                                            "/usr/openwin/bin", 
                                            "/usr/ccs/bin",  
                                            "/usr/sfw/bin",
                                            "/usr/perl5/5.8.4/bin", 
                                            "/opt/SUNWspro/bin"],
                                    cwd => "${tmp_dir}",
                                    creates => "/var/opt/oracle/9.2.0.8_patchset_installed",
                                    environment => ["DISPLAY=:0.0", "MAILTO=DL-ito.bs.dba@is.online.nl"],
                                    logoutput => true,
                                    returns => [0,1],
                                    require => [
                                        File ["wrapper_9.2.0.8.sh"],
                                        File ["wruninstaller_9.2.0.8_patchset.sh"],
                                        Exec ["runinstaller-oui-9201"],
                                        Exec ["9208_stop_oracle_home_proc"],
                                        File["var_opt_oracle"],
                                        File["oracle_home"],
                                        File["oracle_base"],
                                        File["/users/oracle/.bash_profile"],
                                        File["/var/opt/oracle/oraInst.loc"],
                                        File["/users/oracle/.bashrc"],
                                        File["/users/oracle"],
                                        User["oracle"],
                                        Group["dba"],
                                        Group["oinstall"]
                                                ],
                                    timeout => "-1",
                                }

                                # stop  x server, required for the
                                # oracle installer
                                exec {
                                    "9208_stop_vfb":
                                    command => "stop_vfb.sh",
                                    path => ["/users/oracle/bin","/usr/bin", "/usr/sbin", ".", "/opt/csw/bin", "/usr/sbin", "/usr/bin", "/usr/dt/bin", 
                                            "/usr/openwin/bin", "/usr/ccs/bin",  "/usr/sfw/bin", "/usr/perl5/5.8.4/bin", "/opt/SUNWspro/bin"],
                                    cwd => "/users/oracle/bin",
                                    group => "root",
                                    user => "root",
                                    creates => "/var/opt/oracle/stopped_vfb",
                                    environment => ["DISPLAY=:0.0", "MAILTO=DL-ito.bs.dba@is.online.nl"],
                                    logoutput => true,
                                    returns => [0,1],
                                    require => [ 
                                        File["/users/oracle/bin/"],
                                        Exec["runinstaller-patchset-oui-9208"],
                                        File["/users/oracle/bin/stop_vfb.sh"]
                                    ],
                                    timeout => "-1",
                                }

                                file {
                                    "/var/opt/oracle/oracle_db_server_soft_installed":
                                        name => "/var/opt/oracle/oracle_db_server_soft_installed",
                                        mode => 0644,
                                        owner => "oracle",
                                        group => "dba",
                                        require => Exec["runinstaller-patchset-oui-9208"]
                                }

                            }
                            "10.2.0.4": {

                                $disk1_10201_path = "${oracle_base_software}/${architecture}/10.2.0.1/database" 
                                $current_oracle_home = $oracle::directories::oracle_home_path
                                $responsefile_path = "${disk1_10201_path}/response/enterprise.rsp"
                                $current_oracle_base = $oracle::directories::oracle_base_path
                                $orainventory_path = "$current_oracle_base/oraInventory"
                                $tmp_dir = "/var/tmp"


                                # start an x server, required for the
                                # oracle installer
                                exec {
                                    "10204_start_vfb":
                                    command => "start_vfb.sh",
                                    path => ["/users/oracle/bin","/usr/bin", "/usr/sbin", ".", "/opt/csw/bin", "/usr/sbin", "/usr/bin", "/usr/dt/bin", 
                                            "/usr/openwin/bin", "/usr/ccs/bin",  "/usr/sfw/bin", "/usr/perl5/5.8.4/bin", "/opt/SUNWspro/bin"],
                                    cwd => "/users/oracle/bin",
                                    group => "root",
                                    user => "root",
                                    creates => "/var/opt/oracle/started_vfb",
                                    environment => ["DISPLAY=:0.0", "MAILTO=DL-ito.bs.dba@is.online.nl"],
                                    logoutput => true,
                                    returns => [0,1],
                                    require => [ 
                                        File["/users/oracle/bin/"],
                                        File["/users/oracle/bin/start_vfb.sh"]
                                    ],
                                    timeout => "-1",
                                }

                                # build a script to run silent installer
                                # of 10.2.0.1 Disk 1 Oracle database
                                # server software enterprise edition
                                file{
                                    "wruninstaller_10.2.0.1.sh":
                                    name => "${tmp_dir}/wruninstaller_10.2.0.1.sh",
                                    content => template("oracle/wruninstaller_10.2.0.1-template.erb"),
                                    mode => 755,
                                    owner => "oracle",
                                    group => "oinstall", 
                                } 

                                # build a wrapper script 
                                file{
                                    "wrapper_10.2.0.1.sh":
                                    name => "${tmp_dir}/wrapper_10.2.0.1.sh",
                                    content => template("oracle/wrapper_10.2.0.1-template.erb"),
                                    mode => 755,
                                    owner => "oracle",
                                } 
                                
                                # run silent installer of 10.2.0.1 Disk 1
                                # Orable database server software
                                # enterprise edition
                                exec {
                                    "runinstaller-oui-10201":
                                    command => "wrapper_10.2.0.1.sh > ${tmp_dir}/runinstaller-oui_10.2.0.1.log",
                                    path => ["/usr/bin", "/usr/sbin", ".", "/opt/csw/bin", "/usr/sbin", "/usr/bin", 
                                            "/usr/dt/bin", "/usr/openwin/bin", "/usr/ccs/bin",  "/usr/sfw/bin", "/usr/perl5/5.8.4/bin", "/opt/SUNWspro/bin"],
                                    cwd => "${tmp_dir}",
                                    creates => "/var/opt/oracle/10.2.0.1_installed",
                                    environment => ["DISPLAY=:0.0", "MAILTO=DL-ito.bs.dba@is.online.nl"],
                                    logoutput => true,
                                    returns => [0,1],
                                    require => [ 
                                        File ["wrapper_10.2.0.1.sh"],
                                        File ["wruninstaller_10.2.0.1.sh"],
                                        Exec ["10204_start_vfb"],
                                        File["var_opt_oracle"],
                                        File["oracle_home"],
                                        File["oracle_base"],
                                        File["/users/oracle/.bash_profile"],
                                        File["/var/opt/oracle/oraInst.loc"],
                                        File["/users/oracle/.bashrc"],
                                        File["/users/oracle"],
                                        User["oracle"],
                                        Group["dba"],
                                        Group["oinstall"]
                                        ],
                                    timeout => "-1",
                                }

                                # before installing the 10.2.0.4 patchset
                                # we need to shutdown all processes
                                # using the oracle home directories
                                file {
                                    "10204_stop_oracle_home_proc.sh":
                                    name => "${tmp_dir}/stop_oracle_home_proc.sh",
                                    content => template("oracle/stop_oracle_home_proc.erb"),
                                    mode => 755,
                                    owner =>"oracle",
                                    group => "oinstall", 

                                }
    
                                exec {
                                    "10204_stop_oracle_home_proc":
                                    command => "stop_oracle_home_proc.sh > ${tmp_dir}/stop_oracle_home_proc.log",
                                    path => ["/usr/bin", 
                                            "/usr/sbin", 
                                            ".", 
                                            "/opt/csw/bin", 
                                            "/usr/sbin", 
                                            "/usr/bin", 
                                            "/usr/dt/bin", 
                                            "/usr/openwin/bin", 
                                            "/usr/ccs/bin",  
                                            "/usr/sfw/bin",
                                            "/usr/perl5/5.8.4/bin", 
                                            "/opt/SUNWspro/bin"],
                                    cwd => "${tmp_dir}",
                                    group => "dba",
                                    user => "oracle",
                                    environment => ["DISPLAY=:0.0", "MAILTO=DL-ito.bs.dba@is.online.nl"],
                                    logoutput => true,
                                    returns => [0,1],
                                    require => [
                                        Exec ["runinstaller-oui-10201"],
                                        File ["10204_stop_oracle_home_proc.sh"],
                                        File["var_opt_oracle"],
                                        File["oracle_home"],
                                        File["oracle_base"],
                                        File["/users/oracle/.bash_profile"],
                                        File["/var/opt/oracle/oraInst.loc"],
                                        File["/users/oracle/.bashrc"],
                                        File["/users/oracle"],
                                        User["oracle"],
                                        Group["dba"],
                                        Group["oinstall"]
                                                ],
                                    timeout => "-1",
                                    
                                }
                                
                                
                                $disk1_10204_patchset_path = "${oracle_base_software}/${architecture}/patchset_10.2.0.4/Disk1" 
                                $responsefile_patchset_path = "${disk1_10204_patchset_path}/response/patchset.rsp"
                                $products_patchset_path = "${disk1_10204_patchset_path}/stage/products.xml"

                                # build a script to run silent installer
                                # of 10.2.0.4 Disk 1 Oracle database
                                # server software enterprise edition
                                # patchset
                                file{
                                    "wruninstaller_10.2.0.4_patchset.sh":
                                    name => "${tmp_dir}/wruninstaller_10.2.0.4_patchset.sh",
                                    content => template("oracle/wruninstaller_10.2.0.4_patchset-template.erb"),
                                    mode => 755,
                                    owner => "oracle",
                                    group => "oinstall", 
                                } 

                                # build a wrapper script 
                                file{
                                    "wrapper_10.2.0.4.sh":
                                    name => "${tmp_dir}/wrapper_10.2.0.4.sh",
                                    content => template("oracle/wrapper_10.2.0.4-template.erb"),
                                    mode => 755,
                                    owner => "oracle",
                                } 
                                
                                # run silent installer of 10.2.0.4 Disk 1
                                # Orable database server software
                                # enterprise edition patchset
                                exec {
                                    "runinstaller-patchset-oui-10204":
                                    command => 
                                "wrapper_10.2.0.4.sh > ${tmp_dir}/runinstaller-patchset-oui_10.2.0.4.log",
                                    path => ["/usr/bin", 
                                            "/usr/sbin", 
                                            ".", 
                                            "/opt/csw/bin", 
                                            "/usr/sbin", 
                                            "/usr/bin", 
                                            "/usr/dt/bin", 
                                            "/usr/openwin/bin", 
                                            "/usr/ccs/bin",  
                                            "/usr/sfw/bin",
                                            "/usr/perl5/5.8.4/bin", 
                                            "/opt/SUNWspro/bin"],
                                    cwd => "${tmp_dir}",
                                    creates => "/var/opt/oracle/10.2.0.4_patchset_installed",
                                    environment => ["DISPLAY=:0.0", "MAILTO=DL-ito.bs.dba@is.online.nl"],
                                    logoutput => true,
                                    returns => [0,1],
                                    require => [
                                        File ["wrapper_10.2.0.4.sh"],
                                        File ["wruninstaller_10.2.0.4_patchset.sh"],
                                        Exec ["runinstaller-oui-10201"],
                                        Exec ["10204_stop_oracle_home_proc"],
                                        File["var_opt_oracle"],
                                        File["oracle_home"],
                                        File["oracle_base"],
                                        File["/users/oracle/.bash_profile"],
                                        File["/var/opt/oracle/oraInst.loc"],
                                        File["/users/oracle/.bashrc"],
                                        File["/users/oracle"],
                                        User["oracle"],
                                        Group["dba"],
                                        Group["oinstall"]
                                                ],
                                    timeout => "-1",
                                }

                                # stop  x server, required for the
                                # oracle installer
                                exec {
                                    "10204_stop_vfb":
                                    command => "stop_vfb.sh",
                                    path => ["/users/oracle/bin","/usr/bin", "/usr/sbin", ".", "/opt/csw/bin", "/usr/sbin", "/usr/bin", "/usr/dt/bin", 
                                            "/usr/openwin/bin", "/usr/ccs/bin",  "/usr/sfw/bin", "/usr/perl5/5.8.4/bin", "/opt/SUNWspro/bin"],
                                    cwd => "/users/oracle/bin",
                                    group => "root",
                                    user => "root",
                                    creates => "/var/opt/oracle/stopped_vfb",
                                    environment => ["DISPLAY=:0.0", "MAILTO=DL-ito.bs.dba@is.online.nl"],
                                    logoutput => true,
                                    returns => [0,1],
                                    require => [ 
                                        File["/users/oracle/bin/"],
                                        Exec["runinstaller-patchset-oui-10204"],
                                        File["/users/oracle/bin/stop_vfb.sh"]
                                    ],
                                    timeout => "-1",
                                }

                                #

        
                                file {
                                    "/var/opt/oracle/oracle_db_server_soft_installed":
                                        name => "/var/opt/oracle/oracle_db_server_soft_installed",
                                        mode => 0644,
                                        owner => "oracle",
                                        group => "dba",
                                        require => Exec["runinstaller-patchset-oui-10204"]
                                }
                            } #End of 10.2.0.4
                        } #End of case oracle_version
                        
                        
            }# End of solaris 

       }# End of case operating_system
    }# End of define

    install_oracle_database_server_software {
        "oracle database enterprise software":
        oracle_version => $oracle_version,
    }
}

