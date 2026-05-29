prefix       = "terraform"
project      = "eks-setup"
environment  = "dev"
aws_region   = "us-east-1"
cluster_name = "eks-cluster"
# Obrigatorio
cidr_block         = "10.0.0.0/16"
argocd_domain      = "argocd.jhousyfran.click"
route53_zone_id    = "Z07819523R9W5PAE1QMAH"
argocd_server_addr = "https://argocd.jhousyfran.click"
argocd_auth_token  = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhcmdvY2QiLCJzdWIiOiJ0ZXJyYWZvcm06YXBpS2V5IiwibmJmIjoxNzgwMDAzMDU1LCJpYXQiOjE3ODAwMDMwNTUsImp0aSI6ImViZjZlOTA5LWNiOTktNDM2Zi04NzMyLTdmZDE3ZmYxMmQwOCJ9.3x4tCykt4-uomFY1w12GzkM7GRWRyqrFPIXoss-9DjU"
argocd_repo_url    = "https://github.com/Jhousyfran/pos-desafio-2"
apps_domain        = "desafio.jhousyfran.click"
enable_argocd_apps = false
enable_external_secrets_cluster_store = false
