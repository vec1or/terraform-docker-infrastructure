terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "tf-demo-network"
}

resource "docker_volume" "db_data" {
  name = "tf-demo-db-data"
}

resource "docker_image" "postgres" {
  name = "postgres:17"
}

resource "docker_container" "db" {
  name  = "tf-demo-db"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_USER=devops",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=demoapp"
  ]

  networks_advanced {
    name = docker_network.app_network.name
  }

  # Stores PostgreSQL data
  volumes {
    volume_name    = docker_volume.db_data.name
    container_path = "/var/lib/postgresql/data"
  }

  # Database initialization
  volumes {
    host_path      = abspath("${path.module}/init.sql")
    container_path = "/docker-entrypoint-initdb.d/init.sql"
    read_only      = true
  }
}

resource "docker_image" "flask" {
  name = "tf-demo-flask:1.0"
}

resource "docker_container" "app" {
  name  = "tf-demo-flask"
  image = docker_image.flask.image_id

  env = [
    "APP_ENV=development",
    "PORT=5000",
    "DATABASE_URL=postgresql://devops:${urlencode(var.db_password)}@tf-demo-db:5432/demoapp"
  ]

  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 5000
    external = 5002
  }

  depends_on = [docker_container.db]
}