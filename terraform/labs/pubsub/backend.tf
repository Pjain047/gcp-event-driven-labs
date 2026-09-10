terraform {
  backend "gcs" {
    bucket = "gcp-learning-508203-gcp-event-lab-tfstate-91638737"
    prefix = "labs/pubsub"
  }
}
