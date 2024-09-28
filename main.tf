module "stock-market-devops" {
  source = "./stock-market-devops"
  aws_region = "eu-central-1"
  vpc_cidr = "10.10.0.0/16"
  app_image = "strm/helloworld-http"
}


output "alb_hostname" {
  value = module.stock-market-devops.App-Load-Balancer-Hostname
}