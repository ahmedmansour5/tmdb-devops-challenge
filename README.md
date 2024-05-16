# TMDB CHALLENGE

I have created a highly available web application utilizing both Oracle Cloud and Google Cloud to host the TMDB App.

## Reference Architecture 
The final reference architecture after the terraform deployment on both clouds.

![Reference Architecture](./tmdb-assets/Architecture.png)


## Deployment Steps

**Each Directory has its own README.md for instructions**

1. Run the terraform code in tmdb-IaC/gcp/tmdb-infra/ to create all the Infra needed for the APP
2. Run the terraform code in tmdb-IaC/oci/Jenkins-Server/ to create a Jenkins server to host your CI/CD platform (For this task I used Github actions since I don't have credit on OCI)
3. Use the tmdb-keys foler for accessing the servers hosted in the cloud, although I added the private key to 1password for security purposes 
4. Health checks have been added using docker compose for restarting the services automatically, found in tmdb-app/docker-compose.yml

