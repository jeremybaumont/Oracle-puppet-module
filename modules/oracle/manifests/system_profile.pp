
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
### system_profile class is responsible to set up the correct operating                                                                                                                                     
### system profile that is build from a template and inherit variables.                                                                                                                                     
### The system profile will export the famous ORACLE_HOME,                                                                                                                                                  
### ORACLE_SID, ... and else environment variables.                                                                                                                                                         
### 
class oracle::system_profile {
  define oracle_system_profile ($oracle_base_path, $oracle_version,                                                                                                                                       
                                    $oracle_home_path, $oracle_sid,                                                                                                                                         
                                    $oracle_dumps, $oracle_oralogs) {                                                                                                                                       
        file {                                                                                                                                                                                              
            $name:                                                                                                                                                                                          
                content =>
template("oracle/bash_profile.oracle-template.erb"),                                                                                                                             
                mode => 0644, owner => oracle, group => dba                                                                                                                                                 
        }                                                                                                                                                                                                   
    }                                                                                                                                                                                                       
                                                                                                                                                                                                            
    oracle_system_profile {                                                                                                                                                                                 
            "/users/oracle/.bash_profile.oracle":                                                                                                                                                           
                oracle_base_path =>                                                                                                                                                                         
                    $oracle::directories::oracle_base_path,                                                                                                                                
                oracle_version =>                                                                                                                                                                           
                    $oracle::directories::oracle_version,
oracle_home_path =>                         
                    $oracle::directories::oracle_home_path,                                                                                                                                
                oracle_sid =>                                                                                                                                                                               
                    $oracle::directories::oracle_sid,
oracle_dumps =>                             
                    $oracle::directories::oracle_dumps,                                                                                                                                    
                oracle_oralogs =>                                                                                                                                                                           
                    $oracle::directories::oracle_oralogs                                                                                                                                   
                       }                                                                                                                                                                                    
} # end of class oracle::system_profile 

