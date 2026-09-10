Here we are going to have the shared resource accross all the labs such as nebale apis, github role, IAM role etc.

gcloud iam service-account list => to view service account

gcloud iam workload-identity-pools list --location=global => to view workload indetity

gcloud iam workload-identity-pools providers list --location=global --workload-identity-pool=github-pool => to view provider

github_service_account_email = "github-developer@gcp-learning-508203.iam.gserviceaccount.com"
workload_identity_pool = "projects/493306011159/locations/global/workloadIdentityPools/github-pool"
workload_identity_provider = "projects/493306011159/locations/global/workloadIdentityPools/github-pool/providers/github-provider"