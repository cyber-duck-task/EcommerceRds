# Provisioning Multi-AZ RDS(MYSQL) DB_instance on AWS via Terraform

The RDS provisioned on AWS is MySQL compatible and it is set up in Multi-AZ.

Multi-AZ argument would provision the DB instance in different AZs in the same region.

Having the DB instance in different AZs would make the Database highly available and also serve as a disaster recovery.

So basically there will be a main RDS DB_instance set up in AZ(eu-west-2a) whwre our application can read and write.

Similarly, we going to have a standby RDS DB_instance in another AZ(eu-west-2b) with a SYNC REPLICATION between the two DB instance.

So when the aplication reads and writes to the main RDS DB_instance, it will be replicated in the standby RDS DB_instance which serve as a backup for the main RDS DB_instance.

So whenever the main RDS DB_instnace is not responding or allowing the application to reads and writes due to network problem or storage problem, there would be an automatic failover to the standby RDS DB_instance which take over the position of the main RDS DB-instance.
