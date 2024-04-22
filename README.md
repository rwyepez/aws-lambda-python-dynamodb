
# aws-lambda-python-dynamodb

## Descripción
Este proyecto permite realizar operaciones CRUD en una tabla de DynamoDB, la cual es creada y gestionada mediante Terraform. Utiliza AWS Lambda para las operaciones, lo que hace que la solución sea serverless y escalable.

## Requisitos Previos
Antes de comenzar, necesitarás configurar tu entorno con algunas herramientas y configuraciones:

1. **Cuenta AWS**: Debes tener una cuenta de AWS.
2. **AWS CLI**: Instalado y configurado en tu máquina local. [Guía de instalación y configuración de AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
3. **Terraform**: Deberás tener Terraform instalado para realizar pruebas locales y desplegar la infraestructura necesaria. [Descargar Terraform](https://www.terraform.io/downloads.html).

## Configuración Inicial

### Configurar el Estado de Terraform

1. **Crear un Bucket en S3**:
    - Necesitarás un bucket de S3 para manejar el estado de Terraform.
    - Asegúrate de crear el bucket en la región donde deseas desplegar tus recursos.

### Configurar AWS CLI

- Asegúrate de que tu AWS CLI esté configurado correctamente ejecutando:
  ```bash
  aws configure
  ```

## Despliegue de Infraestructura con Terraform

Para desplegar la infraestructura necesaria para este proyecto, sigue los siguientes pasos:

1. **Inicializar Terraform**:
    - Navega al directorio donde se encuentra tu archivo `config.tf`.
    - Inicializa Terraform:
      ```bash
      cd infra
      terraform init
      ```

2. **Planear Cambios**:
    - Verifica los cambios que Terraform aplicará:
      ```bash
      terraform plan
      ```

3. **Aplicar Cambios**:
    - Aplica los cambios para configurar la infraestructura:
      ```bash
      terraform apply --auto-approve
      ```

## Uso

Una vez desplegada la infraestructura, puedes usar las funciones de AWS Lambda para realizar operaciones CRUD en la tabla DynamoDB configurada.

### Eventos de Prueba para AWS Lambda

Para probar las funciones de AWS Lambda desde la consola de AWS, puedes utilizar los siguientes eventos de prueba:

1. **Obtener Información de un Carro (GET)**:
    ```json
    {
      "httpMethod": "GET",
      "path": "/cars",
      "queryStringParameters": {
        "carId": "1"
      }
    }
    ```

2. **Crear un Nuevo Carro (POST)**:
    ```json
    {
      "httpMethod": "POST",
      "path": "/cars",
      "headers": {},
      "body": "{\"carId\": \"1\", \"model\": \"tesla\"}"
    }
    ```

## Contribuir

Si deseas contribuir a este proyecto, por favor considera enviar un pull request con tus cambios o mejoras.

## Licencia

Este proyecto está bajo una licencia libre. Puedes usarlo y modificarlo bajo tus propias responsabilidades y necesidades.
