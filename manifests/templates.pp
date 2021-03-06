
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

node basenode {
    case $operatingsystem {
        solaris: { include solaris }
        default: { include solaris }
    }
    include baseapps
}

node default inherits basenode{}


node oracle_basenode {
    include oracle::administrators
    include oracle::system_packages
}

node oracle_server inherits oracle_basenode {
    include oracle::directories
    include oracle::system_profile
}

node oracle_database_server inherits oracle_server {
   include oracle::software 
}
