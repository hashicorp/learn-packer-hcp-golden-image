## Learn Packer - Build a Golden Image Pipeline

This repo is a companion repo to the [Build a Golden Image Pipeline](https://learn.hashicorp.com/tutorials/packer) tutorial, containing configuration files to create golden virtual machine (VM) images and customize them for downstream uses.

## General Flow
1. Use Packer to build an image for Loki/Grafana and deploy to AWS with Terraform
1. Update config files for golden image with Loki address
1. Create another AMI for the golden image and push metadata about it to HCP
1. Add a `production` channel to the golden image in HCP Packer and choose the built image as the assigned iteration
1. Create another AMI for the Hashicups application built on top of the golden image
1. Add a `production` channel to the Hashicups image in HCP Packer and choose the built image as the assigned iteration
1. Create an instance of the Hashicups image in AWS with Terraform
1. Configure Grafana to show logs from Loki
1. Query the Hashicups API to show log messages in Grafana

## Setup
- AWS credentials set as environment variables
- HCP Packer service principal ID/secret set as environment variables

## Instructions

1. Build and deploy Loki/Grafana image
    ```
    cd golden
    packer init .
    packer build .

    cd ../terraform
    terraform apply -auto-approve
    ```

1. Update golden image config files
    ```
    cd terraform
    
    sed -i "s/LOKI_URL/$(terraform output -raw loki_ip)/g" ../golden/docker-daemon.json    
    sed -i "s/LOKI_URL/$(terraform output -raw loki_ip)/g" ../golden/promtail.yaml

    # Mac versions for above commands
    sed -i '' "s/LOKI_URL/$(terraform output -raw loki_ip)/g" ../golden/docker-daemon.json
    sed -i '' "s/LOKI_URL/$(terraform output -raw loki_ip)/g" ../golden/promtail.yaml
    ```

1. Build golden image

    ```
    cd golden
    packer init .
    packer build .
    ```
  
1. Add `production` channel for golden image
    - Navigate to HCP Packer and click on your golden image ID, click the Channels link on the left of the page, and click on the `+ New Channel` button.
    - Enter `production` as the Channel name, choose your image from the dropdown, and click the `Create channel` button.

1. Build Hashicups image

    ```
    cd hashicups
    packer init .
    packer build .
    ```
  
1. Add `production` channel for Hashicups image
    - Navigate to HCP Packer and click on your Hashicups image ID, click the Channels link on the left of the page, and click on the `+ New Channel` button.
    - Enter `production` as the Channel name, choose your image from the dropdown, and click the `Create channel` button.

1. Create Hashicup instance in AWS
    - Uncomment the `hashicups` `aws_instance` resource block by deleting the `/*` and `*/` lines before and after it, then deploy with Terraform:
    ```
    cd terraform
    terraform apply -auto-approve
    ```
  
1. Setup Grafana
    - Get the value of `loki_ip` from the Terraform output and visit `http://<loki-ip>:3000` to see the Grafana UI. 
    - Login with `admin:admin`.
    - Go to `http://<loki-ip>:3000/datasources`, click the `Add data source` button, and choose `Loki`.
    - In the `URL` field on the next page, enter `http://<loki-ip>:3100`, and click the `Save & test` button at the bottom of the page.

1. Query Hashicups API

    ```
    cd terraform
    ./hashicups-query.sh
    ```

    - Go to the Explore page in Grafana (`http://<loki-ip>:3000/explore`), choose `Loki` from the dropdown at the top of the page, enter the following in the query field just below it, and click the `Run query` button at the top right of the page.
    `{container_name=~"ubuntu_api_1|ubuntu_db_1"}`
