
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
    $architecture = "sparc32"
    $operatingsystem = "solaris"

    $oracle_major_version = "9i"
    $oracle_version = "9.2.0.8"
    $oracle_patch_version = "earth"
    $oracle_sid = "PLGRND"

    include oracle::database_server
}
