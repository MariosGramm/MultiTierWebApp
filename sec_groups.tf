# Security Group : for the ALB , for the Backend Instances , for the Database 


#Security group for the ALB

resource "aws_security_group" "alb_sg" {
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    # ingress {
    #     description = "HTTPS"
    #     from_port   = 443
    #     to_port     = 443 
    #     protocol    = "tcp"
    #     cidr_blocks = ["0.0.0.0./0"]  δεν υπάρχει ούτε listener ούτε target group για την HTTPS κίνηση , άρα καθίσταται περιττή
    # }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    tags = {
      name = "Security Group-ALB"
    }

  
}

#Security Group for the Backend Instances

resource "aws_security_group" "backend_sg" {
    vpc_id          = aws_vpc.my_vpc.id

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = [aws_security_group.alb_sg.id]
    }

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = [aws_security_group.alb_sg.id]
    }

    # ingress {
    #     description = "HTTPS"
    #     from_port   = 443
    #     to_port     = 443
    #     protocol    = "tcp"
    #     cidr_blocks = ["0.0.0.0/0"]
    #     security_groups = [aws_security_group.alb_sg.id]       δεν υπάρχει ούτε listener ούτε target group για την HTTPS κίνηση , άρα καθίσταται περιττή

    #}

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"] 
    }

    tags = {
      name = "Security Group - Backend"
    }


  
}

#Security Group for the Database

resource "aws_security_group" "database_sg" {
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        description     = "MySQL"
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.backend_sg.id] 
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        
    }

    tags = {
        name = "Security Group - RDS"
    }
  
}

