class oracle_administrators {
    include virt_oracle_users, virt_oracle_groups

    realize(
            Group["dba"],
            Group["oinstall"],
            User["oracle"]
           )
}
