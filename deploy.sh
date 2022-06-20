#!/bin/bash
#################################################################################################
# Se asignan las variables
#################################################################################################
localPath=$PWD
baseRep="https://github.com/FloCorvalan/tesis-back-flask-base"
basePath="$localPath/tesis-back-flask-base"
jiraRep="https://github.com/FloCorvalan/tesis-back-flask-jira" 
jiraPath="$localPath/tesis-back-flask-jira"
jenkinsRep="https://github.com/FloCorvalan/tesis-back-flask-jenkins"
jenkinsPath="$localPath/tesis-back-flask-jenkins" 
githubRep="https://github.com/FloCorvalan/tesis-back-flask-gh"
githubPath="$localPath/tesis-back-flask-gh" 
frontRep="https://github.com/FloCorvalan/tesis-front"
frontPath="$localPath/tesis-front"

#################################################################################################
# Se crea la base de datos con persistencia
#################################################################################################
cd "$localPath"
sudo docker-compose up -d mongodb


#################################################################################################
# Se revisa si los repositorios existen, si existen se borran y se clonan, sino solo se clonan
#################################################################################################

# 1 - base
if [ -d "$basePath" ]; then
           
    echo "Se encontro la carpeta $basePath, se borra"    
    sudo rm -r "$basePath"
    git clone $baseRep
else
    echo "Se clona solamente $baseRep"
    git clone $baseRep
fi

# 2 - jira
if [ -d "$jiraPath" ]; then
           
    echo "Se encontro la carpeta $jiraPath, se borra"    
    sudo rm -r "$jiraPath"
    git clone $jiraRep
else
    echo "Se clona solamente $jiraRep"
    git clone $jiraRep
fi

# 3 - jenkins
if [ -d "$jenkinsPath" ]; then
           
    echo "Se encontro la carpeta $jenkinsPath, se borra"    
    sudo rm -r "$jenkinsPath"
    git clone $jenkinsRep
else
    echo "Se clona solamente $jenkinsRep"
    git clone $jenkinsRep
fi

# 4 - github
if [ -d "$githubPath" ]; then
           
    echo "Se encontro la carpeta $githubPath, se actualiza"    
    sudo rm -r "$githubPath"
    git clone $githubRep
else
    echo "Se clona solamente $githubRep"
    git clone $githubRep
fi

# 5 - front
if [ -d "$frontPath" ]; then
           
    echo "Se encontro la carpeta $frontPath, se actualiza"    
    sudo rm -r "$frontPath"
    git clone $frontRep   
else
    echo "Se clona solamente $frontRep"
    git clone $frontRep
fi

#################################################################################################
# Se copian los archivos .env en cada carpeta
#################################################################################################

echo "Copiando archivos .env..."

touch "$basePath/.env"
cp "$localPath/.env-base" "$basePath/.env"

touch "$jiraPath/.env"
cp "$localPath/.env-jira" "$jiraPath/.env"

touch "$jenkinsPath/.env"
cp "$localPath/.env-jenkins" "$jenkinsPath/.env"

touch "$githubPath/.env"
cp "$localPath/.env-github" "$githubPath/.env"

touch "$frontPath/.env"
cp "$localPath/.env-front" "$frontPath/.env"
rm temp.conf
touch temp.conf
set -a
. "$frontPath/.env" && (envsubst '${BASE_PORT}' < "$frontPath/nginx.conf") >> temp.conf
mv temp.conf "$frontPath/nginx.conf"
set +a
echo "Archivo nginx.conf final: "
cat "$frontPath/nginx.conf"

echo "Archivos .env copiados"

#################################################################################################
# Se construyen las imagenes de los contenedores
#################################################################################################

echo "Creando imagenes..."

sudo docker build $basePath -t base-img
echo "Imagen de base creada"

sudo docker build $jiraPath -t jira-img
echo "Imagen de jira creada"

sudo docker build $jenkinsPath -t jenkins-img
echo "Imagen de jenkins creada"

sudo docker build $githubPath -t github-img
echo "Imagen de github creada"

sudo docker build $frontPath -t front-img
echo "Imagen de front creada"

echo "Se han creado todas las imagenes"

#################################################################################################
# Se borran los contenedores si existen
#################################################################################################

echo "Borrando contenedores"

sudo docker stop base-ctr
sudo docker rm base-ctr
echo "Contenedor de base borrado"

sudo docker stop jira-ctr
sudo docker rm jira-ctr
echo "Contenedor de jira borrado"

sudo docker stop jenkins-ctr
sudo docker rm jenkins-ctr
echo "Contenedor de jenkins borrado"

sudo docker stop github-ctr
sudo docker rm github-ctr
echo "Contenedor de github borrado"

sudo docker stop front-ctr
sudo docker rm front-ctr
echo "Contenedor de front borrado"

#################################################################################################
# Se corren los contenedores
#################################################################################################

echo "Ejecutando contenedores..."

sudo docker run --network host -d --name base-ctr base-img
echo "Contenedor de base creado"

sudo docker run --network host -d --name jira-ctr jira-img
echo "Contenedor de jira creado"

sudo docker run --network host -d --name jenkins-ctr jenkins-img
echo "Contenedor de jenkins creado"

sudo docker run --network host -d --name github-ctr github-img
echo "Contenedor de github creado"

sudo docker run --network host -d --name front-ctr front-img
echo "Contenedor de front creado"

echo "Se han ejecutado todos los contenedores"
