# Creates a user to be used for checking the cloud resources

resource "google_project_iam_member" "tmdb_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "user:ahmedmansourua95@gmail.com"
}