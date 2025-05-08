# Terraform AWS Demo - Despliegue de Servidor Web

Este repositorio contiene archivos de configuración de Terraform para desplegar una infraestructura básica en AWS que incluye una VPC, subnet pública, Internet Gateway, grupo de seguridad y una instancia EC2 con un servidor web Nginx.

## Arquitectura

La infraestructura desplegada contiene:

- VPC con CIDR 10.0.0.0/16
- Subnet pública (10.0.1.0/24) en la zona us-west-2a
- Internet Gateway para permitir conexión a Internet
- Tabla de rutas para la subnet pública
- Grupo de seguridad que permite tráfico HTTP (80) y SSH (22)
- Instancia EC2 t2.micro con Ubuntu 20.04 LTS
- Servidor Nginx con una página web simple

## Requisitos previos

Antes de ejecutar esta demo, necesitarás tener lo siguiente:

1. **Terraform CLI** (para macOS se utiliza Homebrew y para Windows recomiendo instalar con Chocolatey)
   - [Instrucciones de instalación de Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

2. **AWS CLI** (opcional, pero útil para verificar recursos)
   - [Instrucciones de instalación de AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

3. **Cuenta de AWS**
   - Necesitarás una cuenta AWS activa
   - Usuario IAM con permisos para crear recursos (EC2, VPC, etc.)

4. **Editor de código** (VS Code, Sublime Text, etc.)

## Configuración de credenciales AWS

### Crear un usuario IAM

1. Inicia sesión en la [Consola de AWS](https://console.aws.amazon.com/)

2. Ve al servicio IAM (Identity and Access Management)

3. En el panel lateral izquierdo, haz clic en "Personas" y luego en "Crear persona"

4. En "Especificar los detalles de la persona" configura el nuevo usuario:
   - Nombre de usuario: `terraform-demo`
   - Haz clic en siguiente

5. En "Adjuntar políticas directamente" configura tus permisos:
   - Selecciona "Adjuntar políticas directamente" en "Opciones de permisos"
   - En "Políticas de permisos" busca y selecciona `AdministratorAccess` (Para una demo, esto es suficiente, pero en entornos de producción, se recomienda usar permisos específicos)
   - Haz clic en siguiente

6. En "Revisar y crear" puedes ver los detalles de nuestro nuevo usuario o "persona"

7. Opcionalmente puedes añadir etiquetas a este usuario si deseas

8. Finalmente, haz click en "Crear persona"

### Obtener credenciales del nuevo usuario

1. Haz click en el nombre del usuario que creaste

2. Selecciona la pestaña "Credenciales de seguridad"

3. En "Claves de acceso" haz click en "Crear clave de acceso"

4. En el Paso 1, selecciona "Servicio de terceros", activa la casilla "Entiendo la recomendación anterior y deseo proceder a la creación de una clave de acceso." y haz click en siguiente

5. En el Paso 2 puedes añadir etiquetas opcionalmente

6. Haz click en "Crear clave de acceso" y luego en "Descargar archivo.csv"

7. **¡IMPORTANTE!** En la pantalla de confirmación, verás:
   - Clave de acceso (access_key)
   - Clave de acceso secreta (secret_key)
   - Descarga el archivo .csv o copia estas credenciales inmediatamente, ya que no podrás ver la Clave de acceso secreta nuevamente

8. Haz click en Listo

### Configurar las credenciales en el proyecto

Tienes dos opciones para configurar las credenciales:

#### Opción 1: Modificar el archivo providers.tf (Si vas a subir el proyecto a tu propio repositorio de github recomiendo reemplazar las claves por texto de relleno nuevamente)

Edita el archivo `providers.tf` y reemplaza:

```hcl
provider "aws" {
  region     = "us-west-2"
  access_key = "TU_ACCESS_KEY"
  secret_key = "TU_SECRET_KEY"
}
```

#### Opción 2: Usar variables de entorno (Recomendado)

1. Elimina o comenta las líneas de access_key y secret_key en `providers.tf`:

```hcl
provider "aws" {
  region = "us-west-2"
  # Las credenciales se tomarán de las variables de entorno
}
```

2. Configura las variables de entorno:

**En Linux/MacOS:**
```bash
export AWS_ACCESS_KEY_ID="TU_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="TU_SECRET_KEY"
export AWS_REGION="us-west-2"
```

**En Windows (PowerShell):**
```powershell
$env:AWS_ACCESS_KEY_ID="TU_ACCESS_KEY"
$env:AWS_SECRET_ACCESS_KEY="TU_SECRET_KEY"
$env:AWS_REGION="us-west-2"
```

## Desplegando la infraestructura

Sigue estos pasos para desplegar la infraestructura:

1. Clona este repositorio:
   ```bash
   git clone https://github.com/tu-usuario/terraform-aws-demo.git
   cd terraform-aws-demo
   ```

2. Inicializa Terraform:
   ```bash
   terraform init
   ```

3. Verifica el plan de ejecución:
   ```bash
   terraform plan
   ```
   Este comando mostrará todos los recursos que se crearán.

4. Aplica la configuración:
   ```bash
   terraform apply
   ```
   Confirma la acción escribiendo `yes` cuando se te solicite.

5. Espera a que se complete el despliegue

6. Accede a la aplicación web navegando a la IP pública de la instancia:
   ```
   http://IP-PUBLICA-DE-TU-INSTANCIA
   ```
   Deberías ver una página web con el mensaje "¡Hola Generation!".

## Eliminar la infraestructura

Para evitar costos innecesarios, elimina los recursos cuando ya no los necesites:

```bash
terraform destroy
```

Confirma la acción escribiendo `yes` cuando se te solicite.

## Buenas prácticas de seguridad

Para entornos de producción, considera las siguientes mejoras:

1. Nunca incluyas credenciales directamente en los archivos de configuración
2. Limita el acceso SSH a IPs específicas en lugar de 0.0.0.0/0
3. Utiliza variables de Terraform para parametrizar tu configuración
4. Implementa alta disponibilidad con múltiples zonas de disponibilidad
5. Utiliza módulos de Terraform para organizar mejor tu código

## Solución de problemas

- **Error de credenciales**: Verifica que tus credenciales AWS estén correctamente configuradas
- **Error de permisos**: Asegúrate de que tu usuario IAM tenga los permisos necesarios
- **Página web no accesible**: Verifica que el grupo de seguridad permita tráfico HTTP en el puerto 80
- **SSH no disponible**: Verifica que el grupo de seguridad permita tráfico SSH en el puerto 22

## Recursos adicionales

- [Documentación oficial de Terraform](https://www.terraform.io/docs/index.html)
- [AWS Provider para Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
