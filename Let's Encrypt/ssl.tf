resource "aws_secretsmanager_secret" "my_secret" {
  name = "my-secret"
}

resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id     = aws_secretsmanager_secret.my_secret.id
  secret_string = "${AWS_ACCESS_KEY_ID}"
}

data "aws_secretsmanager_secret_version" "my_secret" {
  secret_id = aws_secretsmanager_secret.my_secret.id
}

resource "kubernetes_secret" "route53_secret" {
  metadata {
    name = "route53-secret"
    namespace = "cert-manager"
  }

  data = {
    "secret-access-key" = data.aws_secretsmanager_secret_version.my_secret.secret_string
  }

  type = "Opaque"
}
