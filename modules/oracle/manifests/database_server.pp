class database_server {
    
    # required user and groups  
    include oracle::administrators

    # required packages 
    include oracle::system_packages
}
