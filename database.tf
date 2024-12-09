# RDS , subnet group


resource "aws_db_instance" "rds-1" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.username_db
  password             = var.password_db
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.my_subnet_group.name

}


resource "aws_db_subnet_group" "my_subnet_group" {
  name       = "main"
  subnet_ids = [aws_subnet.my_private_subnet_1.id,aws_subnet.my_private_subnet_2.id] 
  tags = {
    Name = "My DB subnet group"
  }
}

