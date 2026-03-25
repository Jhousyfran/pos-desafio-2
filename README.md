# ToggleMaster Tech Challenge – Fase 02

## Vídeo demonstrativo

Gravei um walkthrough em vídeo mostrando a implantação e o fluxo end-to-end. Assista no Loom:

- Link direto: https://www.loom.com/share/2fc9fb3f129f475fb07b10303435cbc0

... (nem todos os renderizadores de README exibem iframes; use o link acima se não aparecer):


Esse repositório reúne a solução da **Fase 2 do Tech Challenge**: transformar o MVP monolítico gerado na Fase 1 em um ecossistema de microsserviços distribuído, todos provisionados e orquestrados na AWS usando EKS, infra como código em Terraform e boas práticas de observabilidade e escalabilidade.

## Desafio descrito no PDF

- Containerizar 5 microsserviços (`auth`, `flag`, `targeting`, `evaluation`, `analytics`) e garantir que cada um rode localmente via `docker-compose`.
- Provisionar os recursos na nuvem: EKS + ECR, três RDS PostgreSQL, ElastiCache Redis, DynamoDB e SQS.
- Configurar o cluster com Metrics Server, NGINX Ingress e secrets/ConfigMaps por serviço.
- Implementar HPA/KEDA, secrets distribuídos pela AWS Secrets Manager, ingress com domínio público, e todo o fluxo de autenticação e avaliação.
- Documentar, demonstrar com vídeo e entregar um relatório com links e colegas envolvidos.

> O PDF inteiro traz o briefing do Tech Challenge, orientando a diferença entre contas com restrição (LabRole) e contas pessoal, além de listar cada um dos entregáveis. A solução abaixo segue a abordagem moderna (contas sem limitação) e traz workarounds para o ambiente em avaliação.

## Nossa solução

1. **Infraestrutura Terraform**  
   - Provisionamos VPC, subnets, EKS, RDS (3 Postgres), ElastiCache e DynamoDB.  
   - Instalamos Metrics Server, ExternalDNS, External Secrets, AWS Load Balancer Controller e KEDA via Helm.  
   - Carregamos ACM + domínio `desafio.jhousyfran.click` para ingress NGINX com rewrite e ALB NLB.
2. **Microserviços & Deploy**  
   - Cada serviço roda em namespace próprio, consome secrets do Secrets Manager e, quando necessário, executa migrations via initContainer.  
   - Ajustamos health/readiness probes, HPAs, ScaledObject do KEDA e ExternalSecret para credenciais e SQS.
3. **Domínio, Argo CD e acesso externo**  
   - O NGINX expõe todos os serviços sob o mesmo host (`desafio.jhousyfran.click`) com paths `/auth`, `/flag`, `/targeting`, `/evaluation` e `/analytics`.  
   - Implantamos o Argo CD para gerenciar os manifests (`infra/modules/apps/*`). O token gerado usando a conta `terraform` (configurada via Helm), aponta o provider Argo CD para `https://argocd.jhousyfran.click`, e todas as aplicações são reconciliadas automaticamente após os pushes. O script `test-flow-eks.sh` também depende desse domínio, então a sincronização via Argo CD garante que os serviços estejam prontos antes dos testes.
4. **Pipeline de testes**  
   - `test-flow-eks.sh` faz healthcheck, cria a API key, define flag/regra e dispara a avaliação final utilizando as URLs públicas com o path correto.
5. **Escalonamento inteligente**  
   - KEDA escala `analytics-service` com base na fila SQS, enquanto os outros serviços têm HPA básico com CPU.

## Passos para rodar

1. **Pré-requisitos**  
   - AWS configurada com credenciais (permissões completas).  
   - Terraform 1.5+, kubectl, AWS CLI, Helm e Docker.

2. **Infra**  
   ```bash
   cd infra
   terraform init
   terraform plan
   terraform apply
   ```
   Defina `infra/terraform.tfvars` com `argocd_server_addr`, `argocd_auth_token`, `apps_domain`, `route53_zone_id` e `argocd_repo_url`.

3. **Commit dos manifests**  
   - Os manifests Kubernetes (namespaces, deployments, services, HPAs, ScaledObject, External Secrets etc.) já estão sob versionamento. Após aplicar o Terraform, sincronize o Argo CD para implantar os apps.

4. **Build local (opcional)**  
   ```bash
   docker compose build
   docker compose up
   ```

5. **Teste o cluster**  
   Rode `bash test-flow-eks.sh` para usar as novas URLs e validar toda a cadeia (auth → flag → targeting → evaluation).

## Observações finais

- **Security**: todos os secrets passam pelo External Secrets + IAM/IRSA.  
- **Escalabilidade**: os serviços críticos têm HPAs, e o `analytics-service` usa KEDA para escalar de 0 para N.  
- **Domínio**: `desafio.jhousyfran.click` mapeia `/auth`, `/flag`, `/targeting`, `/evaluation` e `/analytics`.  
- **Fluxo de uso**: admin gera chave no `auth-service`; `flag-service` e `targeting-service` usam essa chave protegida; `evaluation-service` chama `flag` e `targeting` internamente; `analytics-service` consome SQS e escreve no DynamoDB.

Para detalhes sobre a proposta original, veja o PDF `POSTECH - Tech Challenge - Fase 2.pdf` na raiz.
