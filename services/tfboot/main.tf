resource "random_id" "tf-prj-tfboot-prd-glb-001-rid" {
  byte_length = 2
}

resource "google_folder" "tf-fld-tfboot" {
  display_name = "fld-tfboot"
  parent       = "organizations/603977690773"
}

resource "google_folder" "tf-fld-tfboot-prd" {
  display_name = "fld-tfboot-prd"
  parent       = google_folder.tf-fld-tfboot.name
}

resource "google_project" "tf-prj-tfboot-prd-glb-001" {
  project_id          = "prj-tfboot-prd-glb-001-${random_id.tf-prj-tfboot-prd-glb-001-rid.hex}"
  name                = "prj-tfboot-prd-glb-001-${random_id.tf-prj-tfboot-prd-glb-001-rid.hex}"
  folder_id           = google_folder.tf-fld-tfboot-prd.name
  auto_create_network = false
}

resource "google_service_account" "tf-sva-tfboot-prd-glb-tfadm-001" {
  account_id   = "sva-tfboot-prd-glb-tfadm-001"
  display_name = "sva-tfboot-prd-glb-tfadm-001"
  project      = google_project.tf-prj-tfboot-prd-glb-001.name
}

resource "google_organization_iam_member" "tf-sva-tfboot-prd-glb-tfadm-001-iam-001" {
  org_id     = "603977690773"
  role       = "roles/iam.serviceAccountTokenCreator" # サービスアカウントトークン作成者
  member     = "serviceAccount:${google_service_account.tf-sva-tfboot-prd-glb-tfadm-001.email}"
  depends_on = [google_service_account.tf-sva-tfboot-prd-glb-tfadm-001]
}

resource "google_organization_iam_member" "tf-sva-tfboot-prd-glb-tfadm-001-iam-002" {
  org_id     = "603977690773"
  role       = "roles/resourcemanager.folderCreator" # フォルダ作成者
  member     = "serviceAccount:${google_service_account.tf-sva-tfboot-prd-glb-tfadm-001.email}"
  depends_on = [google_service_account.tf-sva-tfboot-prd-glb-tfadm-001]
}

resource "google_storage_bucket" "tf-gcs-tfboot-prd-glb-tfstate-001" {
  name          = "gcs-tfboot-prd-glb-tfstate-001"
  location      = "asia-northeast1"
  force_destroy = false
  storage_class = "STANDARD"
  project = google_project.tf-prj-tfboot-prd-glb-001.name
}