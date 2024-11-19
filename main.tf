resource "aws_launch_template" "web_server_as" {
    image_id           = "ami-0166fe664262f664c"
    instance_type = "t2.micro"
    key_name = "final"
    security_group_ids = [aws_security_group.web_server.id]
}
   


  resource "aws_elb" "web_server_lb"{
     name = "web-server-lb"
     security_group_ids = [aws_security_group.web_server.id]
     subnets = ["subnet-0666db147aab6bfd4", "subnet-0f19eec39b164fd41"]
     listener {
      instance_port     = 8000
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    launch_template_name = aws_launch_template.web_server_as.name
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    availability_zones    = ["us-east-1", "us-east-2"] 
    
  }

