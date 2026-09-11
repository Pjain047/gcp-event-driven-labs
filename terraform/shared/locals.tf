locals {
  apis = [
    "run.googleapis.com",
    "cloudfunctions.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "pubsub.googleapis.com",
    "cloudtasks.googleapis.com",
    "eventarc.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "firestore.googleapis.com",
    "monitoring.googleapis.com"
  ]

  deployer_roles = [
    "roles/run.admin",
    "roles/cloudfunctions.admin",
    "roles/artifactregistry.admin",
    "roles/cloudbuild.builds.editor",
    "roles/pubsub.admin",
    "roles/cloudtasks.admin",
    "roles/eventarc.admin",
    "roles/storage.viewer",
    "roles/iam.serviceAccountTokenCreator",
    "roles/datastore.user"
  ]
}
