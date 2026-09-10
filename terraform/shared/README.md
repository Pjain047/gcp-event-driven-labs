Here we are going to have the shared resource accross all the labs such as nebale apis, github role, IAM role etc.

gcloud iam service-account list => to view service account

gcloud iam workload-identity-pools list --location=global => to view workload indetity

gcloud iam workload-identity-pools providers list --location=global --workload-identity-pool=github-pool => to view provider

