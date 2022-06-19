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
sudo docker-compose up -d


#################################################################################################
# Se revisa si los repositorios existen, si existen se actualizan (pull) sino se clonan
#################################################################################################

# 1 - base
if [ -d "$basePath" ]; then
           
    echo "se encontro la carpeta $basePath, se actualiza"    
    echo "comando: cd $basePath"
    cd "$basePath"
    echo "comando: git pull origin main"
    git pull origin main        
else
    echo "se clona $baseRep"
    echo "comando: git clone $baseRep"
    git clone $baseRep
fi

# 2 - jira
if [ -d "$jiraPath" ]; then
           
    echo "se encontro la carpeta $jiraPath, se actualiza"    
    echo "comando: cd $jiraPath"
    cd "$jiraPath"
    echo "comando: git pull origin main"
    git pull origin main        
else
    echo "se clona $jiraRep"
    echo "comando: git clone $jiraRep"
    git clone $jiraRep
fi

# 3 - jenkins
if [ -d "$jenkinsPath" ]; then
           
    echo "se encontro la carpeta $jenkinsPath, se actualiza"    
    echo "comando: cd $jenkinsPath"
    cd "$jenkinsPath"
    echo "comando: git pull origin main"
    git pull origin main        
else
    echo "se clona $jenkinsRep"
    echo "comando: git clone $jenkinsRep"
    git clone $jenkinsRep
fi

# 4 - github
if [ -d "$githubPath" ]; then
           
    echo "se encontro la carpeta $githubPath, se actualiza"    
    echo "comando: cd $githubPath"
    cd "$githubPath"
    echo "comando: git pull origin main"
    git pull origin main        
else
    echo "se clona $githubRep"
    echo "comando: git clone $githubRep"
    git clone $githubRep
fi

# 5 - front
if [ -d "$frontPath" ]; then
           
    echo "se encontro la carpeta $frontPath, se actualiza"    
    echo "comando: cd $frontPath"
    cd "$frontPath"
    echo "comando: git pull origin main"
    git pull origin main        
else
    echo "se clona $frontRep"
    echo "comando: git clone $frontRep"
    git clone $frontRep
fi

#################################################################################################
# Se copian los archivos .env en cada carpeta
#################################################################################################

echo "Copiando archivos .env..."

cp "$localPath/.env-base" "$basePath/.env"
cp "$localPath/.env-jira" "$jiraPath/.env"
cp "$localPath/.env-jenkins" "$jenkinsPath/.env"
cp "$localPath/.env-github" "$githubPath/.env"
cp "$localPath/.env-front" "$frontPath/.env"

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
