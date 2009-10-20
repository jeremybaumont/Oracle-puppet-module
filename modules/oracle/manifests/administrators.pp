class oracle::administrators {
    include oracle::virt_users, oracle::virt_groups

    realize(
            Group["dba"],
            Group["oinstall"],
            User["oracle"]
           )
}
