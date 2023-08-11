# Ref: https://github.com/antonputra/tutorials/tree/main/lessons/108
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
# resource "google_service_account" "service-a" {
#   account_id = "service-a"
# }

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
# resource "google_project_iam_member" "service-a" {
#   project = var.project_id
#   role    = "roles/storage.admin"
#   member  = "serviceAccount:${google_service_account.service-a.email}"
# }

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
# resource "google_service_account_iam_member" "service-a" {
#   service_account_id = google_service_account.service-a.id
#   role               = "roles/iam.workloadIdentityUser"
#   member             = "serviceAccount:${var.project_id}.svc.id.goog[staging/service-a]"
# }