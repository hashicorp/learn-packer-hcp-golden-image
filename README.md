## Learn Packer - Build a Golden Image Pipeline

This repo is a companion repo to the [Build a Golden Image Pipeline](https://learn.hashicorp.com/tutorials/packer) tutorial, containing configuration files to create golden virtual machine (VM) images and customize them for downstream uses.

## General Flow
1. Use Packer to build a golden image (AMI) and push metadata about it to HCP
1. Add a `production` channel to the golden image in HCP Packer and choose the built image as the assigned iteration
1. Create another AMI for Loki/Grafana
1. Create another AMI for the Hashicups application built on top of the golden image
1. Add a `production` channel to the Hashicups image in HCP Packer and choose the built image as the assigned iteration
1. Create instances of the Loki/Grafana and Hashicups images (and associated resources) in AWS with Terraform
1. Configure Grafana to show logs from Loki
1. Query the Hashicups API to show log messages in Grafana

## Setup
- AWS credentials set as environment variables
- HCP Packer service principal ID/secret set as environment variables

## Instructions

1. Build golden image

    ```
    cd golden
    packer init .
    packer build .
    ```
  
2. Add `production` channel for golden image
    - Navigate to HCP Packer and click on your golden image ID, click the Channels link on the left of the page, and click on the `+ New Channel` button.
    - Enter `production` as the Channel name, choose your image from the dropdown, and click the `Create channel` button.

3. Build Loki/Grafana image

    ```
    cd loki
    packer init .
    packer build .
    ```

4. Build Hashicups image

    ```
    cd hashicups
    packer init .
    packer build .
    ```
  
5. Add `production` channel for Hashicups image
    - Navigate to HCP Packer and click on your Hashicups image ID, click the Channels link on the left of the page, and click on the `+ New Channel` button.
    - Enter `production` as the Channel name, choose your image from the dropdown, and click the `Create channel` button.

6. Create instances in AWS

    ```
    cd terraform
    terraform apply -auto-approve
    ```
  
7. Setup Grafana
    - Get the value of `loki_ip` from the Terraform output and visit `http://<loki-ip>:3000` to see the Grafana UI. 
    - Login with `admin:admin`.
    - Go to `http://<loki-ip>:3000/datasources`, click the `Add data source` button, and choose `Loki`.
    - In the `URL` field on the next page, enter `http://<loki-ip>:3100`, and click the `Save & test` button at the bottom of the page.

8. Query Hashicups API

    ```
    cd terraform
    ./hashicups-query.sh
    ```

    - Go to the Explore page in Grafana (`http://<loki-ip>:3000/explore`), choose `Loki` from the dropdown at the top of the page, enter the following in the query field just below it, and click the `Run query` button at the top right of the page.
    `{container_name=~"ubuntu_api_1|ubuntu_db_1"}`
