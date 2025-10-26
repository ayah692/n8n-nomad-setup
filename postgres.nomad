job "postgres" {
  datacenters = ["dc1"]
  type = "service"

  group "postgres-group" {
    count = 1

    network {
      mode = "bridge"
      port "db" {
        static = 5432
      }
    }

    task "postgres" {
      driver = "docker"

      config {
        image = "postgres:latest"
        ports = ["db"]
      }

      env {
        POSTGRES_USER     = "admin"
        POSTGRES_PASSWORD = "mypassword"
        POSTGRES_DB       = "n8ndb"
      }

      volume_mount {
        volume      = "postgres-data"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }
    }

    volume "postgres-data" {
      type      = "host"
      source    = "postgres-data"
      read_only = false
    }
  }
}

