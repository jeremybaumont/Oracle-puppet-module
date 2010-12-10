#    directories.pp - oracle database server software 9i/10g
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


# puppet manages the following directories, they may not following OFA
# but feel free to modify at your convenience
#
# ORACLE_BASE
# /opt/app/oracle
#
# ORACLE_HOME
# /opt/app/oracle/product/11.2.0/earth
#
# Inventory
# /opt/app/oracle/oraInventory
#
# Data Directory
# /ora06/dbsid/dbf/
# /ora07/dbsid/dbf/
#
# Control Files
# /ora01/dbsid/ctl
# /ora02/dbsid/ctl
# /ora03/dbsid/ctl
#
# Redo Logs
# /ora01/dbsid/redo
# /ora02/dbsid/redo
# /ora03/dbsid/redo
#
# Archives
# /ora04/dbsid/arch/
#
# Dumps
# /logs/oracle/diag/rdbms/db_name/db_sid/udump....
#
# Flashback
# /flash_recovery_area/dbsid
#
# RMAN
# /rman-backup

class oracle::directories {

    define oracle_dir ( $path, $ensure, $owner, $group, $mode ) {
        file {
            $name:
            path => $path,
            ensure => $ensure,
            force => true,
            owner => $owner,
            group => $group,
            recurse => false,
            mode => $mode
        }
    }

    
    # required directories
    oracle_dir {
        "var_opt":
            path => "/var/opt",
            ensure => directory,
            owner => "root",
            group => "root",
            before => File["var_opt_oracle"],
            mode => 755
    }

#    oracle_dir {
#        "/logs":
#            path => "/logs",
#            ensure => directory,
#            owner => "root",
#            group => "root",
#            mode => 755
#    }


    oracle_dir {
        "var_opt_oracle":
            path => "/var/opt/oracle",
            ensure => directory,
            owner => "oracle",
            group => "oinstall",
            require => File["var_opt"],
            mode => 755
    }

    oracle_dir {
        "/opt/app":
            path => "/opt/app",
            ensure => directory,
            owner => "root",
            group => "root",
            before => File["oracle_base"],
            mode => 755
    }
    
    $oracle_base_path = "/opt/app/oracle"
    $orainventory_path = "$oracle_base_path/oraInventory"
    file {
        "/var/opt/oracle/oraInst.loc":
            content => template("oracle/oraInst-template.erb"),
            ensure => present,
            force => true,
            owner => "oracle",
            group => "oinstall",
            mode => 644
    }

    oracle_dir { 
       "oracle_base":
        path => $oracle_base_path,
        ensure => directory,
        owner => "oracle",
        group => "oinstall",
        before => [
                    File["oracle_home"],
                    File["oracle_major_version"],
                    File["oracle_product"]
                ],
        require => File["/opt/app"],
        mode => 755 
    }

    oracle_dir {
        "oracle_product":
        path => "${oracle_base_path}/product",
        ensure => directory,
        owner => "oracle",
        group => "oinstall",
        require => File["oracle_base"],
        before => [
                    File["oracle_home"],
                    File["oracle_major_version"],
                ],
        mode => 755
    }


    oracle_dir {
        "oracle_major_version":
        path => "${oracle_base_path}/product/${oracle_major_version}",
        ensure => directory,
        owner => "oracle",
        group => "oinstall",
        require => [ 
                    File["oracle_base"],
                    File["oracle_product"]
                ],
        before => [
                    File["oracle_home"],
                ],
        mode => 755 
    }


    $oracle_home_path = "${oracle_base_path}/product/${oracle_major_version}/${oracle_patch_version}"
    oracle_dir { 
        "oracle_home":
        path => "${oracle_home_path}",  
        ensure => directory,
        owner => "oracle",
        group => "oinstall",
        require => [
                    File["oracle_base"],
                    File["oracle_major_version"],
                ],
        mode => 755
    }


    $oracle_ora01 = "/ora01"
    $oracle_ora02 = "/ora02"
    $oracle_ora03 = "/ora03"
    $oracle_ora04 = "/ora04"
    $oracle_ora06 = "/ora06"
    $oracle_ora07 = "/ora07"

    oracle_dir {
        "oracle_ora01":
        path => "${oracle_ora01}",
        ensure => directory,
        owner => "oracle",
        group => "dba",
        before => [
                    File["oracle_ora01_dbsid"],
                    File["oracle_ora01_dbf"],
                ],
        mode => 755
    }       

    oracle_dir {
        "oracle_ora02":
        path => "${oracle_ora02}",
        ensure => directory,
        owner => "oracle",
        group => "dba",
        before => [
                    File["oracle_ora02_dbsid"],
                    File["oracle_ora02_dbf"],
                ],
        mode => 755
    }       

    oracle_dir {
        "oracle_ora03":
        path => "${oracle_ora03}",
        ensure => directory,
        owner => "oracle",
        group => "dba",
        before => [
                    File["oracle_ora03_dbsid"],
                    File["oracle_ora03_dbf"],
                ],
        mode => 755
    }       

    oracle_dir {
        "oracle_ora04":
        path => "${oracle_ora04}",
        ensure => directory,
        owner => "oracle",
        group => "dba",
        before => [
                    File["oracle_ora04_dbsid"],
                    File["oracle_ora04_dbf"],
                ],
        mode => 755
    }       

    oracle_dir {
        "oracle_ora06":
        path => "${oracle_ora06}",
        ensure => directory,
        owner => "oracle",
        group => "dba",
        before => [
                    File["oracle_ora06_dbsid"],
                    File["oracle_ora06_dbf"],
                ],
        mode => 755
    }       

    oracle_dir {
        "oracle_ora07":
        path => "${oracle_ora07}",
        ensure => directory,
        owner => "oracle",
        group => "dba",
        before => [
                    File["oracle_ora07_dbsid"],
                    File["oracle_ora07_dbf"],
                ],
        mode => 755
    }       


    oracle_dir {
        "oracle_ora01_dbsid":
        path => "${oracle_ora01}/${oracle_sid}",
        ensure => directory,
        owner => "oracle",
        require => File["oracle_ora01"],
        before => File["oracle_ora01_dbf"],
        group => "dba",
        mode => 755
    }       

    oracle_dir {
        "oracle_ora02_dbsid":
        path => "${oracle_ora02}/${oracle_sid}",
        ensure => directory,
        owner => "oracle",
        require => File["oracle_ora02"],
        before => File["oracle_ora02_dbf"],
        group => "dba",
        mode => 755
    }       

    oracle_dir {
        "oracle_ora03_dbsid":
        path => "${oracle_ora03}/${oracle_sid}",
        ensure => directory,
        owner => "oracle",
        require => File["oracle_ora03"],
        before => File["oracle_ora03_dbf"],
        group => "dba",
        mode => 755
    }       

    oracle_dir {
        "oracle_ora04_dbsid":
        path => "${oracle_ora04}/${oracle_sid}",
        ensure => directory,
        owner => "oracle",
        require => File["oracle_ora04"],
        before => File["oracle_ora04_dbf"],
        group => "dba",
        mode => 755
    }       

    oracle_dir {
        "oracle_ora06_dbsid":
        path => "${oracle_ora06}/${oracle_sid}",
        ensure => directory,
        owner => "oracle",
        require => File["oracle_ora06"],
        before => File["oracle_ora06_dbf"],
        group => "dba",
        mode => 755
    }       

    oracle_dir {
        "oracle_ora07_dbsid":
        path => "${oracle_ora07}/${oracle_sid}",
        ensure => directory,
        owner => "oracle",
        require => File["oracle_ora07"],
        before => File["oracle_ora07_dbf"],
        group => "dba",
        mode => 755
    }       

    oracle_dir{
        "oracle_ora01_dbf":
        path => "${oracle_ora01}/${oracle_sid}/dbf",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora01"],
                    File["oracle_ora01_dbsid"],
                ],
        group => "dba",
        mode => 755
    }

    oracle_dir{
        "oracle_ora02_dbf":
        path => "${oracle_ora02}/${oracle_sid}/dbf",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora02"],
                    File["oracle_ora02_dbsid"],
                ],
        group => "dba",
        mode => 755
    }

    oracle_dir{
        "oracle_ora03_dbf":
        path => "${oracle_ora03}/${oracle_sid}/dbf",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora03"],
                    File["oracle_ora03_dbsid"],
                ],
        group => "dba",
        mode => 755
    }


    oracle_dir{
        "oracle_ora04_dbf":
        path => "${oracle_ora04}/${oracle_sid}/dbf",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora04"],
                    File["oracle_ora04_dbsid"],
                ],
        group => "dba",
        mode => 755
    }

    oracle_dir{
        "oracle_ora06_dbf":
        path => "${oracle_ora06}/${oracle_sid}/dbf",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora06"],
                    File["oracle_ora06_dbsid"],
                ],
        group => "dba",
        mode => 755
    }

    oracle_dir{
        "oracle_ora07_dbf":
        path => "${oracle_ora07}/${oracle_sid}/dbf",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora07"],
                    File["oracle_ora07_dbsid"],
                ],
        group => "dba",
        mode => 755
    }

    oracle_dir{
        "oracle_ora01_ctl":
        path => "${oracle_ora01}/${oracle_sid}/ctl",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora01"],
                    File["oracle_ora01_dbsid"],
                ],
        group => "dba",
        mode => 755
    }

    oracle_dir{
        "oracle_ora02_ctl":
        path => "${oracle_ora02}/${oracle_sid}/ctl",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora02"],
                    File["oracle_ora02_dbsid"],
                ],
        group => "dba",
        mode => 755
    }

    oracle_dir{
        "oracle_ora03_ctl":
        path => "${oracle_ora03}/${oracle_sid}/ctl",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora03"],
                    File["oracle_ora03_dbsid"],
                ],
        group => "dba",
        mode => 755
    }

    oracle_dir{
        "oracle_ora01_redo":
        path => "${oracle_ora01}/${oracle_sid}/redo",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora01"],
                    File["oracle_ora01_dbsid"],
                ],
        group => "dba",
        mode => 755
    }

    oracle_dir{
        "oracle_ora02_redo":
        path => "${oracle_ora02}/${oracle_sid}/redo",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora02"],
                    File["oracle_ora02_dbsid"],
                ],
        group => "dba",
        mode => 755
    }

    oracle_dir{
        "oracle_ora03_redo":
        path => "${oracle_ora03}/${oracle_sid}/redo",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora03"],
                    File["oracle_ora03_dbsid"],
                ],
        group => "dba",
        mode => 755
    }

    oracle_dir{
        "oracle_ora04_arch":
        path => "${oracle_ora04}/${oracle_sid}/arch",
        ensure => directory,
        owner => "oracle",
        require => [
                    File["oracle_ora04"],
                    File["oracle_ora04_dbsid"],
                ],
        group => "dba",
        mode => 755
    }

    $oracle_logs = "/logs/oracle"
    oracle_dir {
        "oracle_logs":
        path => "${oracle_logs}",
        ensure => directory,
        owner => "oracle",
        group => "dba",
        require => File["/logs"],
        mode => 755
    }


} # end of class oracle::directories
