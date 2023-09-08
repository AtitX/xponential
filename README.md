## Deploying S3 and DynamoDB

First, we will deploy the S3 bucket and DynamoDB.

```
cd backend/
terraform init
terraform plan
terraform apply
```

Update S3 bucket name in `backend.conf`

Uncomment the remote backend code block

Reinitialize our S3 bucket as our new remote state backend. 
Terraform will ask if this is the intended action, type `yes` to proceed.

```
terraform init -backend-config=../backend.conf -backend-config="key=state/terraform.tfstate"
```

## Deploy

The main directory to run Terraform is in `environment/` directory. Once you change directory into it and set the environment variables, you can run the following commmands:

### Initialize Terraform configuration

```
cd environment/
terraform init -backend-config=../backend.conf -backend-config="key=terraform.tfstate"
```

### Dev

```
terraform workspace new dev
terraform plan -var-file="../dev.tfvars"
terraform apply -var-file="../dev.tfvars"
```
### Prod

```
terraform workspace new prod
terraform plan -var-file="../prod.tfvars"
terraform apply -var-file="../prod.tfvars"
```

## Validate

The following command will update the kubeconfig on your local machine and allow you to interact with your EKS Cluster using kubectl to validate the deployment.

Run `update-kubeconfig` command:

```
aws eks --region <REGION> update-kubeconfig --name <CLUSTER_NAME>
```

View the pods that were created:

```
kubectl get pods -A

# Output should show some pods running
NAMESPACE     NAME                       READY   STATUS    RESTARTS   AGE
kube-system   aws-node-56ldg             2/2     Running   0          12m
kube-system   aws-node-b9tqb             2/2     Running   0          12m
kube-system   aws-node-vfkfc             2/2     Running   0          13m
kube-system   coredns-6bbdd6bcfd-hpxpc   1/1     Running   0          13m
kube-system   coredns-6bbdd6bcfd-rz2qv   1/1     Running   0          13m
kube-system   kube-proxy-pwts5           1/1     Running   0          13m
kube-system   kube-proxy-qssz7           1/1     Running   0          13m
kube-system   kube-proxy-tg4s7           1/1     Running   0          13m
```

## Destroy

To teardown and remove the resources:
```
terraform destroy -var-file="../dev.tfvars" -auto-approve
rm -rf terraform.tfstate*
rm -rf .terraform*
```

Migrate backend back to local

```
terraform init -migrate-state
terraform destroy -auto-approve
rm -rf terraform.tfstate*
rm -rf .terraform*
```

## Automating Terraform Deployments and Infrastructure Provisioning

Automation of Terraform can come in various forms, and to varying degrees. Some teams continue to run Terraform locally but use wrapper scripts to prepare a consistent working directory for Terraform to run in, while other teams run Terraform entirely within an orchestration tool such as Jenkins.

- Building infrastructure provisioning pipelines

  This is the most common approach for running Terraform in automation is to build infrastructure provisioning pipelines with a CI/CD tool.

-  AWS Control Tower Account Factory for Terraform (AFT), a new Terraform module maintained by the AWS Control Tower team that allows you to provision and customize AWS accounts through Terraform using a deployment pipeline that comply with your organization's security guidelines. The source code for the development pipeline can be stored in AWS CodeCommit, GitHub, GitHub Enterprise, or BitBucket. With AFT, you can automate the creation of fully functional accounts that have access to all the resources they need to be productive. Account Factory for Terraform (AFT) sets up a Terraform pipeline to help you provision and customize accounts in AWS Control Tower. AFT provides you with the advantage of Terraform-based account provisioning while allowing you to govern your accounts with AWS Control Tower.
