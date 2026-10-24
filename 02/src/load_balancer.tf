resource "yandex_lb_network_load_balancer" "lamp" {
  name = "lamp-network-load-balancer"

  listener {
    name = "http"
    port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp.load_balancer[0].target_group_id

    healthcheck {
      name                = "http"
      interval            = 5
      timeout             = 2
      healthy_threshold   = 2
      unhealthy_threshold = 2

      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}
