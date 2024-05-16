# Creates a user to be used for checking the cloud resources

resource "google_project_iam_member" "tmdb_viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "user:ahmedmansourua95@gmail.com"
}