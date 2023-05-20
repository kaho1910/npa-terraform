##################################################################################
# RESOURCES
##################################################################################
# DATABASES #

resource "aws_db_instance" "MysqlDB" {
  allocated_storage    = 10
  db_name              = "testdb"
  engine               = "mysql"
  identifier           = "mysqlinstance"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "adminroot1234"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.instancsSG.id]
}
