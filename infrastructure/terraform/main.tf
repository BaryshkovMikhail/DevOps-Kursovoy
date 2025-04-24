resource "yandex_vpc_network" "main" {
  name = "main-network"
}

resource "yandex_vpc_subnet" "private" {
  count          = 2
  name           = "private-subnet-${count.index}"
  zone           = "ru-central1-${element(["a", "b"], count.index)}"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.0.${count.index}.0/24"]
}

resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "web-${count.index}"
  platform_id = "standard-v2"
  zone        = "ru-central1-${element(["a", "b"], count.index)}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd827b91d99psvq5fjit" # Ubuntu 20.04
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private[count.index].id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}