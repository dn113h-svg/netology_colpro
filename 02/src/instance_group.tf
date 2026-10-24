resource "yandex_iam_service_account" "instance_group" {
  name = "instance-group-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "instance_group_compute_editor" {
  folder_id = var.folder_id
  role      = "compute.editor"
  member    = "serviceAccount:${yandex_iam_service_account.instance_group.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "instance_group_load_balancer_editor" {
  folder_id = var.folder_id
  role      = "load-balancer.editor"
  member    = "serviceAccount:${yandex_iam_service_account.instance_group.id}"
}

resource "yandex_compute_instance_group" "lamp" {
  name               = "lamp-instance-group"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.instance_group.id

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      mode = "READ_WRITE"

      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 10
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.network.id
      subnet_ids = [yandex_vpc_subnet.public.id]
    }

    metadata = {
      user-data = <<-EOF
        #!/bin/bash
        cat > /var/www/html/index.html <<'HTML'
        <!doctype html>
        <html>
        <head>
          <meta charset="utf-8">
          <title>LAMP Instance Group</title>
        </head>
        <body>
          <h1>LAMP Instance Group</h1>
          <p>Host: $(hostname)</p>
          <img src="https://storage.yandexcloud.net/${yandex_storage_bucket.images.bucket}/${yandex_storage_object.image.key}" alt="Object Storage image">
        </body>
        </html>
        HTML
        systemctl enable apache2
        systemctl restart apache2
      EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  health_check {
    interval            = 5
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 3

    http_options {
      port = 80
      path = "/index.html"
    }
  }

  load_balancer {
    target_group_name = "lamp-target-group"
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.instance_group_compute_editor,
    yandex_resourcemanager_folder_iam_member.instance_group_load_balancer_editor
  ]
}
