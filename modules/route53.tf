
data "aws_route53_zone" "sockshop" {
  name = "fiiyinfoluwa.live"
}


# Create a Route53 record to point to the Ingress Controller
resource "aws_route53_record" "sockshop" {
   zone_id = data.aws_route53_zone.sockshop.zone_id
   name    = "*.fiiyinfoluwa.live"
   type    = "CNAME"
   ttl     = 300
   records = [data.kubernetes_service.nginx-service.status.0.load_balancer.0.ingress.0.hostname]
}

