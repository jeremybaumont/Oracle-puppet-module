
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

node 'jeremy-test.wanadoo.nl' {
    $architecture = "sparc64"
    $oracle_major_version = "10g"
    $operatingsystem = "solaris"
    $oracle_version = "10.2.0.4"
    $oracle_patch_version = "earth"

    include  oracle::database_server 
    
}
