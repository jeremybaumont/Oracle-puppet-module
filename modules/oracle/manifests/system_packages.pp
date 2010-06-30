
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


class oracle::system_packages {

    case $operatingsystem {                                                                                                                                                                                 
        "solaris": {                                                                                                                                                                                        
            $sun_provider = "sun"                                                                                                                                                                           
            case $oracle_version {                                                                                                                                                                    
                "10.2.0.4": {                                                                                                                                                                                    
                    case $architecture {                                                                                                                                                                    
                        "sparc64": {                                                                                                                                                                        
                            $system_packages = ["SUNWarc", "SUNWbtool", "SUNWhea", "SUNWlibm", "SUNWlibms", "SUNWsprot", "SUNWtoo", "SUNWi1of", "SUNWi1cs", "SUNWi15cs", "SUNWxwfnt", "SUNWsprox"]          
                        }                                                                                                                                                                                   
                        "sparc32": {                                                                                                                                                                        
                            $system_packages = ["SUNWarc", "SUNWbtool", "SUNWhea", "SUNWlibm", "SUNWlibms", "SUNWsprot", "SUNWtoo", "SUNWi1of", "SUNWi1cs", "SUNWi15cs", "SUNWxwfnt"]                       
                        }                                                                                                                                                                                   
                        default: {                                                                                                                                                                          
                            fail("INFO - the architecture $architecture is not                                                                                                           
                                yet supported by class system_packages.")                                                                                                                                   
                        }                                                                                                                                                                                   
                    }                                                                                                                                                                                       
                }                                                                                                                                                                                           
                "9.2.0.8": {                                                                                                                                                                                     
                    case $architecture {                                                                                                                                                                    
                        "sparc64": {                                                                                                                                                                        
                            $system_packages = ["SUNWarc", "SUNWbtool", "SUNWhea", "SUNWlibm", "SUNWlibms", "SUNWsprot", "SUNWtoo", "SUNWi1of", "SUNWxwfnt"]                                                
                         }                                                                                                                                                                                  
                        "sparc32": {                                                                                                                                                                        
                            $system_packages = ["SUNWarc", "SUNWbtool", "SUNWhea", "SUNWlibm", "SUNWlibms", "SUNWsprot", "SUNWtoo", "SUNWi1of", "SUNWxwfnt"]                                                
                        }                                                                                                                                                                                   
                                                                                                                                                                                                            
                        default: {                                                                                                                                                                          
                            fail("INFO - the architecture $architecture is not                                                                                                           
                                yet supported by class system_packages.")                                                                                                                                   
                        }                                                                                                                                                                                   
                    }                                                                                                                                                                                       
                }                                                                                                                                                                                           
                                                                                                                                                                                                            
                default: {                                                                                                                                                                                  
                        fail("INFO - the oracle version $oracle_version is not                                                                                                     
                           yet support by class system_packages.")                                                                                                                                          
                    }                                                                                                                                                                                       
            }                                                                                                                                                                                               
        }                                                                                                                                                                                                               
    }                                                                                                                                                                                                       
                                                                                                                                                                                                            
    notify {"INFO - the operating system is ${operatingsystem}": }                                                                                                                       
    notify {"INFO - the architecture is ${architecture}": }                                                                                                                              
    notify {"INFO - the architecture is ${oracle_major_version}": }                                                                                                                      
    notify {"INFO - the list of packages required is ${system_packages}": }                                                                                                              
                                                                                                                                                                                                            
    package { $system_packages: ensure => installed, provider => $sun_provider } 

}# end of class oracle::system_packages
