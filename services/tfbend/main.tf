resource "random_id" "tf-prj-tfbend-prd-glb-001-rid" {
  byte_length = 2
}

resource "google_folder" "tf-fld-tfbend" {
  display_name = "fld-tfbend"
  parent       = "organizations/603977690773"
}

resource "google_folder" "tf-fld-tfbend-prd" {
  display_name = "fld-tfbend-prd"
  parent       = google_folder.tf-fld-tfbend.name
}

resource "google_project" "tf-prj-tfbend-prd-glb-001" {
  project_id          = "prj-tfbend-prd-glb-001-${random_id.tf-prj-tfbend-prd-glb-001-rid.hex}"
  name                = "prj-tfbend-prd-glb-001-${random_id.tf-prj-tfbend-prd-glb-001-rid.hex}"
  folder_id           = google_folder.tf-fld-tfbend-prd.name
  auto_create_network = false
}

resource "google_service_account" "tf-sva-tfbend-prd-glb-tfadm-001" {
  account_id   = "sva-tfbend-prd-glb-tfadm-001"
  display_name = "sva-tfbend-prd-glb-tfadm-001"
  project      = google_project.tf-prj-tfbend-prd-glb-001.name
}

resource "google_organization_iam_member" "tf-sva-tfbend-prd-glb-tfadm-001-iam-001" {
  org_id     = "603977690773"
  role       = "roles/iam.serviceAccountTokenCreator" # サービスアカウントトークン作成者
  member     = "serviceAccount:${google_service_account.tf-sva-tfbend-prd-glb-tfadm-001.email}"
  depends_on = [google_service_account.tf-sva-tfbend-prd-glb-tfadm-001]
}

resource "google_organization_iam_member" "tf-sva-tfbend-prd-glb-tfadm-001-iam-002" {
  org_id     = "603977690773"
  role       = "roles/resourcemanager.folderCreator" # フォルダ作成者
  member     = "serviceAccount:${google_service_account.tf-sva-tfbend-prd-glb-tfadm-001.email}"
  depends_on = [google_service_account.tf-sva-tfbend-prd-glb-tfadm-001]
}


