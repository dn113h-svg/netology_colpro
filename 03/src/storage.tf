resource "yandex_storage_bucket" "images" {
  bucket    = var.bucket_name
  folder_id = var.folder_id

  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_object" "image" {
  bucket       = yandex_storage_bucket.images.bucket
  key          = "image.png"
  source       = "${path.module}/image.png"
  content_type = "image/png"
}

resource "yandex_storage_object" "site" {
  bucket       = yandex_storage_bucket.images.bucket
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
}
