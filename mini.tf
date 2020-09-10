provider "kubernetes" {

  config_context = "minikube"

}

resource "kubernetes_deployment" "minikube_app" {

  metadata {

    name = "wordpress"

    labels = {

      test = "wp_system"

    }

  }



  spec {

    replicas = 5



    selector {

      match_labels = {

        env = "Development"

        dc = "IN"

        App = "wordpress"

      }

    match_expressions {

        key = "env"

        operator = "In"

        values = ["Development", "wordpress"]

    }

  }



    template {

      metadata {

        labels = {

        env = "Development"

        dc = "IN"

        App = "wordpress"

        }

      }



        spec {

        container {

          image = "wordpress"

          name  = "cont"

        }

        }

    }

  }

}



resource "kubernetes_service" "service" {

  metadata {

    name = "loadbalancer"

  }

  spec {

    selector = {

      App = kubernetes_deployment.minikube_app.spec.0.template.0.metadata[0].labels.App

    }

    port {

      node_port = 30000

      port        = 80

      target_port = 80

    }



    type = "NodePort"

  }

}


resource "null_resource" "minikube_app" {

provisioner "local-exec" {

command = "minikube service list"

}
depends_on = [

kubernetes_deployment.minikube_app

]
}