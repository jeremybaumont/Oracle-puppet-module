
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
class oracle::virt_users  {

    @user { oracle:
        ensure  => present,
        uid     => 500,
        gid     => 500,
        groups  => ["dba", "oinstall" ],
        comment => "Oracle Application User",
        home    => "/users/oracle",
        require => [ Group["dba"], Group["oinstall"] ,]
        shell   => "/usr/bin/bash",
    }

        file {
        "/users/oracle/":
            ensure => directory,
            mode => 0750, owner => oracle, group => dba;
        "/users/oracle/.bashrc":
            source => "$fileserver/users/oracle/.bashrc",
            ensure => present, replace => true,
            mode => 0640, owner => oracle, group => dba;
        "/users/oracle/.bash_profile":
            source => "$fileserver/users/oracle/.bash_profile",
            ensure => present, replace => true,
            mode => 0640, owner => oracle, group => dba;
        "/users/oracle/.ssh":
            ensure => directory,
            mode => 0700, owner => oracle, group => dba;
        "/users/oracle/.ssh/authorized_keys":
            source => "$fileserver/users/oracle/.ssh/authorized_keys",
            ensure => present, replace => true,
            mode => 0600, owner => oracle, group => dba;
#        "/users/oracle/.ssh/config":
#            source => "$fileserver/users/oracle/.ssh/config",
#            mode => 0600, owner => oracle, group => dba;
    }
}
