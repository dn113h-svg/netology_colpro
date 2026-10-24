resource "yandex_storage_bucket" "images" {
  bucket    = var.bucket_name
  folder_id = var.folder_id

  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }
}

resource "yandex_storage_object" "image" {
  bucket       = yandex_storage_bucket.images.bucket
  key          = "image.png"
  source       = "${path.module}/image.png"
  content_type = "image/png"
}
