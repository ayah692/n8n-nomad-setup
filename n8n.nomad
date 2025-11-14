job "n8n" {
  datacenters = ["dc1"]
  type = "service"

  group "n8n-group" {

    network {
      mode = "bridge"
      port "web" {}
    }

    task "n8n" {
      driver = "docker"

      config {
        image = "n8nio/n8n:latest"
        ports = ["web"]
      }

      env {
        DB_TYPE                 = "postgresdb"
        DB_POSTGRESDB_HOST      = "postgres.service.consul"
        DB_POSTGRESDB_PORT      = "5432"
        DB_POSTGRESDB_DATABASE  = "n8ndb"
        DB_POSTGRESDB_USER      = "admin"
        DB_POSTGRESDB_PASSWORD  = "mypassword"
      }

      service {
        name = "n8n"
        port = "web"
      }

      resources {
        network {
          bandwidth = "10mb"

          port "web" {}
        }
      }

      volume_mount {
        volume      = "n8ndata"
        destination = "/home/node/.n8n"
        read_only   = false
      }
    }

    volume "n8ndata" {
      type      = "host"
      read_only = false
      source    = "n8ndata"
    }
  }
}
