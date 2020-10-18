# Instrucciones

## Usando Docker

- Seguir las instrucciones contenidas en https://hub.docker.com/r/mdillon/postgis
- Luego de tener configurada la base de datos 
    - Usar un DBMS para conectarse a la base de datos
    - Ejecutar el contenido de postGis.sql
 
## Usando Docker Compose (Recomendado)

- Si no cuenta con docker - compose puede instalarlo ingresando aqui: https://docs.docker.com/compose/install/
- Clone el repositorio o Descarge el Zip del contenido
- Dentro de una consola ( si se encuentra en windows puede usar gitbash ) ejecutar los siguientes comandos:
    - docker-compose up -d 
    - docker ps ( para verificar que el contenedor está arriba )
- Usando un DBMS ( recomendado usar DATAGRIP => https://www.jetbrains.com/es-es/datagrip/ )
    - Conectarse a la base de datos PostgreSQL (credenciales en el archivo postGIS.sql)
        - consideración: conectarse usando el puerto 25432
    - Ejecutar el archivo postGIS.sql o ejecutar cada una de las sentencias SQL dentro de la consola del DBMS
