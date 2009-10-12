class oracle_administrators {
    include oracle::virt_oracle_users, oracle::virt_oracle_groups

    realize(
            Group["dba"],
            Group["oinstall"],
            User["oracle"]
           )
}
