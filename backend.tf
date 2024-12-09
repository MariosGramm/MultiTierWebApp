# Launch Template(EC2 Instances) , Autoscaling group , NAT Gateway 


#Launch Template for the EC2 Instances

resource "aws_launch_template" "app_template" {
  name_prefix   = "app-template"
  image_id      = "ami-0866a3c8686eaeeba" 
  instance_type = "t2.micro"
  key_name      = "key-pair-1"

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y     
    sudo bash -c 'echo "<html><body><h1>This is a test page for my Nginx server!</h1></body></html>" > /var/www/html/index.html'
    sudo systemctl restart nginx
    EOF
  )
    #Nginx αντί Apache για το φόρτο συνδέσεων

}


#Autoscaling group

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.my_private_subnet_1.id]
  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.target_group-alb_80.arn]
}

#NAT Gateway ώστε τα backend instances να έχουν πρόσβαση στο διαδίκτυο(π.χ για ενημερώσεις) χωρίς να είναι προσβάσιμα από το διαδίκτυο

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.my_public_subnet_1.id
}



resource "aws_eip" "nat_eip" {                 
  depends_on = [aws_launch_template.app_template]
  domain     = "vpc"
}

output "alb_public_ip" {
  value = aws_lb.my_alb.dns_name
  description = "Public DNS name of the ALB"
}




