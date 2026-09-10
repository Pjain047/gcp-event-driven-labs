# gcp-event-driven-labs
This repo has been created to learn GCP along with DevOps (Terraform)

$PROJECT_ID = "gcp-learning"

gcloud config set project $PROJECT_ID => to set project on local CLI

gcloud auth login => to login local from cli

gcloud auth application-default login => for terraform login locally as terraform's google providers uses application default credentials

gcloud config get-value project => to view project name
gcloud auth list => to view auth list

tfsate_bucket created => gcp-learning-508203-gcp-event-lab-tfstate-91638737

to view details about bucket from cli 

gcloud storage buckets describe "gs://gcp-learning-508203-gcp-event-lab-tfstate-91638737"

gcloud storage ls "gs://<bucketname>" => to view objects inside bucket