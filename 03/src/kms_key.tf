
resource "yandex_kms_symmetric_key" "key-a" {
  name              = "bucket-symetric-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}