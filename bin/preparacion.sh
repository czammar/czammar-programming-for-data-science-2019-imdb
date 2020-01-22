##################### Nos ubicamos en el directorio principal ##############

cd ..

##################### Descargamos los archivos que contienen la información de la base de datos

#wget https://datasets.imdbws.com/name.basics.tsv.gz
#wget https://datasets.imdbws.com/title.akas.tsv.gz
#wget https://datasets.imdbws.com/title.basics.tsv.gz
#wget https://datasets.imdbws.com/title.crew.tsv.gz
#wget https://datasets.imdbws.com/title.episode.tsv.gz
#wget https://datasets.imdbws.com/title.principals.tsv.gz
#wget https://datasets.imdbws.com/title.ratings.tsv.gz

# Se reemplazan link de descargas con las ultimas versiones de la base dado que el servidor arrojo errores; en caso que se desen probar basta descomentar lo de arriba y comentar las de abajo
curl gdrive.sh | bash -s https://drive.google.com/file/d/1iLni46rXXwXlqLdU0xWK9zIilUKdpcnS/view?usp=sharing
curl gdrive.sh | bash -s https://drive.google.com/file/d/1U8tYLyD8nwsU0vr-5AXjdM4QH5vPOcd2/view?usp=sharing
curl gdrive.sh | bash -s https://drive.google.com/file/d/1PLFW26QYHpa-NigZuNyTL_8-kqkq2Tnz/view?usp=sharing
curl gdrive.sh | bash -s https://drive.google.com/file/d/1NxdznWKuporOItQ84MEKN4zOsB6heLxj/view?usp=sharing
curl gdrive.sh | bash -s https://drive.google.com/file/d/1uqkWrLHwCILNU0Exk0g3wwhXOuNC1ZtO/view?usp=sharing
curl gdrive.sh | bash -s https://drive.google.com/file/d/1-gxrZSNvxqwTlQcJgrlQgPOuaTzjn046/view?usp=sharing
curl gdrive.sh | bash -s https://drive.google.com/file/d/14xDrW_WZnxB3SgLOFKPHdJjF67XHWT3Q/view?usp=sharing

##################### Extraemos los archivos que están comprimidos

gunzip name.basics.tsv.gz
gunzip title.akas.tsv.gz
gunzip title.basics.tsv.gz
gunzip title.crew.tsv.gz
gunzip title.episode.tsv.gz
gunzip title.principals.tsv.gz
gunzip title.ratings.tsv.gz



##################### Quitamos la primer línea de cada archivo (trabajaremos sin headers)

sed -i 1d name.basics.tsv
sed -i 1d title.akas.tsv
sed -i 1d title.basics.tsv
sed -i 1d title.crew.tsv
sed -i 1d title.episode.tsv
sed -i 1d title.principals.tsv
sed -i 1d title.ratings.tsv

##################### Removemos caracteres extraños para lograr la carga

cat name.basics.tsv | sed 's/\\N/NA/g' | sed 's/\"/?????/g' > name_basics.tsv
cat title.akas.tsv | sed 's/\\N/NA/g' | sed 's/\"/?????/g' > title_akas.tsv
cat title.basics.tsv | sed 's/\\N/NA/g' | sed 's/\"/?????/g' > title_basics.tsv
cat title.crew.tsv | sed 's/\\N/NA/g' | sed 's/\"/?????/g' > title_crew.tsv
cat title.episode.tsv | sed 's/\\N/NA/g' | sed 's/\"/?????/g' > title_episode.tsv
cat title.principals.tsv | sed 's/\\N/NA/g' | sed 's/\"/?????/g' > title_principals.tsv
cat title.ratings.tsv | sed 's/\\N/NA/g' | sed 's/\"/?????/g' > title_ratings.tsv

##################### Eliminamos los archivos en los que se basó el cambio de caracteres

rm name.basics.tsv
rm title.akas.tsv
rm title.basics.tsv
rm title.crew.tsv
rm title.episode.tsv
rm title.principals.tsv
rm title.ratings.tsv

##################### Segmentamos los archivos grandes para que no se desborde la memoria

split -l 10000000 title_akas.tsv split-title_akas-
split -l 10000000 title_principals.tsv split-title_principals-
split -l 1000000 title_basics.tsv split-title_basics-

##################### Eliminamos los archivos en los que se basó la segmentación

rm title_akas.tsv # elimina el archivo que se divido
rm title_principals.tsv # elimina el archivo que se divido
rm title_basics.tsv # elimina el archivo que se divido

##################### Renombramos los archivos separados

mv split-title_akas-aa split-title_akas-aa.tsv
mv split-title_akas-ab split-title_akas-ab.tsv

mv split-title_principals-aa split-title_principals-aa.tsv
mv split-title_principals-ab split-title_principals-ab.tsv
mv split-title_principals-ac split-title_principals-ac.tsv
mv split-title_principals-ad split-title_principals-ad.tsv

mv split-title_basics-aa split-title_basics-aa.tsv
mv split-title_basics-ab split-title_basics-ab.tsv
mv split-title_basics-ac split-title_basics-ac.tsv
mv split-title_basics-ad split-title_basics-ad.tsv
mv split-title_basics-ae split-title_basics-ae.tsv
mv split-title_basics-af split-title_basics-af.tsv
mv split-title_basics-ag split-title_basics-ag.tsv
mv split-title_basics-ah split-title_basics-ah.tsv
mv split-title_basics-ai split-title_basics-ai.tsv
mv split-title_basics-aj split-title_basics-aj.tsv
mv split-title_basics-ak split-title_basics-ak.tsv

##################### Movemos los archivos a la carpeta de datos correspondiente

mv name_basics.tsv data_imdb/
mv split-title_akas-aa.tsv data_imdb/
mv split-title_akas-ab.tsv data_imdb/
mv split-title_basics-aa.tsv data_imdb/
mv split-title_basics-ab.tsv data_imdb/
mv split-title_basics-ac.tsv data_imdb/
mv split-title_basics-ad.tsv data_imdb/
mv split-title_basics-ae.tsv data_imdb/
mv split-title_basics-af.tsv data_imdb/
mv split-title_basics-ag.tsv data_imdb/
mv split-title_basics-ah.tsv data_imdb/
mv split-title_basics-ai.tsv data_imdb/
mv split-title_basics-aj.tsv data_imdb/
mv split-title_basics-ak.tsv data_imdb/
mv title_crew.tsv data_imdb/
mv title_episode.tsv data_imdb/
mv split-title_principals-aa.tsv data_imdb/
mv split-title_principals-ab.tsv data_imdb/
mv split-title_principals-ac.tsv data_imdb/
mv split-title_principals-ad.tsv data_imdb/
mv title_ratings.tsv data_imdb/

