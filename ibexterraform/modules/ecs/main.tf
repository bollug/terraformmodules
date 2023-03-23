resource "aws_cloudwatch_log_group" "example" {
  name = "example"
}

data "aws_region" "current" {}

resource "aws_ecs_cluster" "cluster" {
  name = "example"

#   configuration {
#     log_configuration {
#       cloud_watch_log_group_name     = aws_cloudwatch_log_group.example.name
#       }
#     }
  }

resource "aws_iam_role" "ecsiam_role" {
  name = "ecsservice_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { 
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess" , "arn:aws:iam::aws:policy/AmazonECS_FullAccess" , "arn:aws:iam::aws:policy/CloudWatchFullAccess" , "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]
}

resource "aws_iam_role" "executionrole" {
  name = "ecsexecution_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { 
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess" , "arn:aws:iam::aws:policy/AmazonECS_FullAccess" , "arn:aws:iam::aws:policy/CloudWatchFullAccess" , "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]
}
resource "aws_iam_role" "taskrole" {
  name = "ecstask_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { 
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess" , "arn:aws:iam::aws:policy/AmazonECS_FullAccess" , "arn:aws:iam::aws:policy/CloudWatchFullAccess" , "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]
}

resource "aws_security_group" "contsgg" {
  name = var.contsg
  vpc_id = var.vpcid
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}


resource "aws_ecs_task_definition" "taskdef" {
  family = "task"
  execution_role_arn       = aws_iam_role.executionrole.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 3072
  task_role_arn            = aws_iam_role.taskrole.arn
  
  container_definitions = <<EOF
[{

    "image": "nginx:latest",
    "name": "${var.containername}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080 ,
        "protocol" : "tcp"
      }
    ],

    "logConfiguration": {
      "logDriver": "awslogs" ,
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.example.name}",
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-stream-prefix": "ecs"
       }
    }
}]

EOF

}

resource "aws_ecs_service" "service" {
  depends_on      = [aws_lb_target_group.tg]
  name            = "example"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.taskdef.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.contsgg.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = var.containername
    container_port   = 8080
  }
}

resource "aws_security_group" "lbsgg" {
  name = var.lbsg
  vpc_id = var.vpcid
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}
resource "aws_lb" "test" {
  name               = "elb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lbsgg.id]
  subnets            = var.publicsubnetsids
}

resource "aws_lb_target_group" "tg" {
  name        = "tf-example-lb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpcid
}

resource "aws_lb_listener" "front_endhttp" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "front_end" {
#   depends_on      = [aws_lb.test]  
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:794605155433:certificate/05366ec7-e04c-4669-9776-47d8edead320"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_route53_record" "ecs" {
  zone_id = var.hostedzoneid
  name    = var.domainname
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.test.dns_name]
}


