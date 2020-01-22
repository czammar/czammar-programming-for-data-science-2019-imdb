# Proyecto Final - Programación para Ciencia de Datos


**Profesor:** Adolfo de Unanúe Tiscareño

 **Fecha:** 12 de diciembre de 2019

**Integrantes del equipo**

| # | Nombre | Clave |
|---|----------------------------|--------|
| 1 | Laura Gómez Bustamante | 191294 |
| 2 | Miguel Ángel Millán Dorado | 191401 |
| 3 | César Zamora Martínez | 190609 |
| 4 | Marco Julio Monroy Ayala | 187825 |

***

### 0. Introducción

El presente documento expone las consideraciones realizadas para el proyecto final del Seminario de Programación sobre la Internet Movie Database (IMDB), considerando las instrucciones que permiten la creación de una base de datos asociada a ésta, su limpieza y conformación de un esquema semantic a través de PostgreSQL (Postgres).

Para consolidar el material desarrollado se creó un repositorio de Github (disponible a través de la dirección electrónica https://github.com/czammar/czammar-programming-for-data-science-2019-imdb) que sigue la estructura de carpetas sugerida en el curso para el desarrollo de un proyecto.

En este sentido, debe entenderse que los diferentes archivos y programas desarrollados (en Bash, Python y Postgres) se encuentran dentro de este directorio de trabajo, con lo cual, para seguir el desarrollo realizado para este proyecto se debe clonar el repositorio en cuestión para ejecutar el código implementado, lo cual se realiza con la siguiente instrucción:
```
git clone https://github.com/lauragmz/lauragmz-programming-for-data-science-2019-imdb
```

Es así que a continuación se expondrá el enfoque seguido para el desarrollo del proyecto en cuestión.

##### Nota sobre el equipo empleado para el desarrollo del proyecto

Se resalta que para trabajar de manera colectiva en el proyecto, todo el desarrollo fue probado en la máquina virtual Vagrant, considerando un ambiente virtual de Python (ver sección 5.1),
 por lo que en caso de correrse en un equipo de manera local habrá que cerciorarse que este cuente con la herramientas necesarias de Python y PostgreSQL.

De manera particular, para la instalación de manera local de Pyenv se pueden realizarse los siguientes pasos:

```
curl https://pyenv.run | bash # script de instalacion de pyenv
# sudo rm -r /home/user/.pyenv # en caso de existir error ante la presencia del
#archivo de configuración de pyenv, descomentar y sustituir

# se agregan diferentes especificaciones para el
# funcionamiento de Pyenv
export PATH="/home/user/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

### 1. Descripción de la fuente de datos

IMDB contiene información relacionada con diferentes medios de entretenimiento visual, tales como películas, programas de televisión y video juegos; incluyendo casting, equipo de producción, biografías personales; así como información sobre los raitings (véase https://www.imdb.com/interfaces/#plain).

De acuerdo a la documentación, dicha base se integra por siete conjuntos de datos denominados i) title_basics, ii) title_akas, iii) title_crew, iv) title_episode, v) title_principals, vi) title_ratings y vii) name_basics; los cuales se actualizan de manera diaria y que se encuentran disponibles para su descarga en la dirección electrónica https://datasets.imdbws.com/.

**Nota:** Cabe destacar que debido a las actualizaciones diarias de la base de datos IMBD a veces se presentan problemas para la descarga de los datos de manera automatizada, por esta razón se decidió emplear un corte de la información en su versión más reciente a la elaboración del proyecto los cuales se alojaron dentro de una cuenta en Google Drive. Sin embargo, si se desea realizar el ejercicio con la base presente en https://datasets.imdbws.com/, se deberán descomentar las líneas 7 a 13 del archivo preparación.sh, y comentar las líneas 16 a 22.

A continuación se ofrece un resumen del contenido de tales conjuntos de datos:

* **title_basics:** describe características especiales de los títulos de las películas; tales como el tipo del título, el título más popular, el título original, la clasificación adulto o no, los años de inicio  y fin (en caso de las series de televisión), la duración y el género.

* **title_akas:** relativa  al título adaptado de las películas a través de la región para esta versión del título, el idioma y los atributos asociados. Además indica si el título es original o no.

* **title_crew:** contiene los nombres del director y los escritores de los títulos de IMDB.

* **title_episode:** incluye información de los episodios de series de tv, considerando la temporada a la que pertenece el episodio así como el número de episodio.

* **title_principals:** describe los principales miembros del equipo de producción de las películas,considerando un identificador de la persona, la categoría del trabajo de la persona, el trabajo específico y el nombre del personaje.

* **title_ratings:** referente a los raitings y votos de las películas,a través  del peso promedio de todos los individuos que usan raitings; así como el número de votos que el título ha recibido.

* **name_basics:** contiene la información principal de actores, directores, escritores y demás involucrados en los títulos, en términos del nombre por el cual la persona es "most often credited", año de nacimiento, año de muerte, el top-3 de las profesiones de las personas y títulos por los cuáles la persona es conocida.


### 2. Descripción de la entidad

En la industria del entretenimiento uno de los puestos más relevantes es el del director, dado que esta persona se encarga de la organización de organizar todas las actividades que soportan la pre-producción, rodaje y post-producción de una obra, como el estudio del guión, la selección de locaciones de filmación, edición, entre otras. Tales actividades son determinantes para el recibimiento del público y su éxito comercial.

En tal sentido, la elección de una persona apropiada para el puesto de director en un factor relevante a considerar sobre el impacto de una obra de entretenimiento y su triunfo, que típicamente si mide en el nivel de raiting.

Con ello en mente, se puede plantear un esquema que permita a los tomadores de decisiones, encarnados por los productores de contenido (televisoras, plataformas digitales, estudios de cine) predecir el nivel de raiting que tendrá el capítulo de serie bajo la tutela de un director en una ventana de tiempo, dada la elección de una persona específica en su dirección, para evaluar si vale la pena abordar un proyecto, junto con los riesgos asociados a su inversión.

De todo lo anterior, se plantea que considerar a los directores de series como entidades que sirvan para modelar este problema específico, sobre un periodo de interés.

Al respecto, de acuerdo a la información de IMDB, para dicha entidades las características estáticas que pueden considerar son:

* Nombre del director,
* Año de nacimiento,
* *Primary profesion*, el conjunto de actividades principales que desarrollar en las obras de entrentenimiento,
* El valor promedio de sus raitings.

Por otra lado, en una ventana de tiempo, los eventos que les ocurren a las entidades, es decir a si tales dirigieron el capítulo de una serie específica en función de:

* el nombre de la serie,
* el año que inició y término de la serie,
* el año del término de cada capítulo,
* el número de la temporada y el episodio correspondiente,
* el género de la serie,
* si la serie es para adultos.

Lo anterior, se propone como información que puede ser relevante para predecir el nivel de raiting que tendrá el capítulo de una serie bajo la dirección de una persona.

### 3. Estructura de la base de datos

De acuerdo a la información proporcionada para IMDB (ver https://www.imdb.com/interfaces/#plain), así como derivado del análisis de los conjuntos de datos de ésta, se tiene que la información en cuestión se puede describir como:


**Cuadro 1:** Tabla describiendo las columnas de la relación *title_akas*,

| elemento   | descripción                                            | observación                                                                     |
|------------|--------------------------------------------------------|---------------------------------------------------------------------------------|
| titleid      | identificador del título                              |                                                                                 |
| ordering   | identificador de las filas de un título                |                                                                                 |
| title  | nombre adaptado del titulo                              |                                                                                 |
| region     | región de la versión del título adaptado               |                                                                                 |
| language   | idioma del título adaptado                             |                                                                                 |
| types      | conjunto de atributos del título adaptado             | posibles valores "alternative", "dvd", "festival", "tv", "video", "working",etc |
| atributes  | términos adicionales para describir el título adaptado |                                                                                 |
| isoriginaltitle | indica si el título adaptado corresponde al original   | posibles valores "0 : not original title", "1: original title"                  |


**Cuadro 2:** Tabla describiendo las columnas de la relación *title_basics*,

| **elemento**   | **descripción**                | **observación**                                                         |
|----------------|--------------------------------|-------------------------------------------------------------------------|
| tconst          | identificador del título      |                                                                         |
| titletype      | tipo o formato del título      | posibles valores "movie", "short", "tvseries", "tvepisode", "video",etc |
| primarytitle   | nombre más popular del título  |                                                                         |
| originaltitle  | título en el idioma original  |                                                                         |
| isadult        | clasificador del título        | posibles valores "0: no adulto", "1: adulto"                            |
| startyear      | año de realización del título  | en el caso de "tvseries" corresponde al año de inicio                   |
| endyear        | año de termino de "tvseries"   |                                                                         |
| runtimeminutes | duración en minutos del título |                                                                         |
| genres         | género del título              | incluye hasta tres géneros                                              |



**Cuadro 3:** Tabla describiendo las columnas de la relación *title_crew*,

| **elemento** | **descripción**            | **observación** |
|--------------|----------------------------|-----------------|
| tconst        | identificador del título   |                 |
| directors    | identificador del director |                 |
| writers   | identificador del escritor |                 |




**Cuadro 4:** Tabla describiendo las columnas de la relación *title_episode*,


| **elemento**  | **descripción**                                    | **observación** |
|---------------|----------------------------------------------------|-----------------|
| tconst         | identificador del título                           |                 |
| parenttconst        | identificador del padre de las "tvseries"          |                 |
| seasonnumber  | número de temporada a la que pertenece el episodio |                 |
| episodenumber | número de episodio en la "tvseries"                |                 |


**Cuadro 5:** Tabla describiendo las columnas de la relación *title_principals*,

| **elemento** | **descripción**                                    | **observación**               |
|--------------|----------------------------------------------------|-------------------------------|
| tconst        | identificador del título                           |                               |
| ordering     | identificador de las filas de un título            |                               |
| nconst        | identificador de la persona                        |                               |
| category     | categoría de trabajo a la que pertenece la persona |                               |
| job          | trabajo específico de la persona                   |                               |
| characters   | nombre del personaje representado                  | en caso de resultar aplicable |

**Cuadro 6:** Tabla describiendo las columnas de la relación *title_ratings*,

| **elemento**  | **descripción**                                         | **observación** |
|---------------|---------------------------------------------------------|-----------------|
| tconst         | identificador del título                                |                 |
| averagerating | promedio ponderado de los ratings de todos los usuarios |                 |
| numvotes      | número de votos por título                              |                 |

**Cuadro 7:** Tabla describiendo las columnas de la relación *name_basics*,

| **elemento**      | **descripción**                            | **observación**                    |
|-------------------|--------------------------------------------|------------------------------------|
| nconst              | identificador de la persona                |                                    |
| primaryname       | nombre más popular de la persona           |                                    |
| birthyear         | año de nacimiento de la persona             | en formato YYYY                    |
| deathyear         | año de muerte de la persona                | en formato YYYY, en caso aplicable |
| primaryprofession | top 3 de profesiones de la persona         |                                    |
| knownfortitles    | títulos por los que la persona es conocida |                                    |

En complemento, del análisis a la información recién presentada y según lo expuesto en la documentación de IMDB, el diagrama entidad-relación de IMDB es:


![Diagrama de entidad-relacion de IMDB](references/EDR.jpeg)
**Nota:** El símbolo "+" en este diagrama se emplea para especificar la relación en torno a la cual giran la diversas entidades.


Nota: dicho diagrama también se encuentra disponible para su consulta a través del directorio /references.

### 4. Pipeline

A continuación se describirán las etapas consideradas para realizar la creación de la base de datos, su limpieza y posterior inicio del esquema semantic. Cabe destacar que las instrucciones para la ejecución del pipeline se detallan en las secciones 5 y 6, siendo la primera de éstas la que se avoca a  dar los pasos para la descarga del conjunto de datos IMDB.

**Notas:** 1) a menos que se indique lo contrario, los archivos .sql , que se mencionan en esta sección se encontrarán ubicados en la carpeta *sql*.

#### 4.1 Creación de la base de datos y rol

El primer punto consiste en establecer dentro de Postgres la base de datos que se va a trabajar para IMDB así como la creación
de un rol que tenga permisos de administración sobre la misma.

Para fines de este proyecto, se implementó el archivo *preparar_base.sql* el cual se encarga de realizar tales acciones creando una
base de datos denominada **bd_IMDB**, mientras que el rol será **rol_IMDB** cuyo password es **1234**.

#### 4.2 Creación de esquemas

Para crear los esquemas que se usan con la base de datos IMDB, se implementó el archivo *create_schemas.sql* el cual se encarga de indicar a Postgres la creación de esquemas denominados *raw*, *cleaned* y *semantic* que se emplearán en etapas posteriores.

#### 4.3 Creación de raw tables

En complemento, para declarar las estructuras de datos básicas que conforman al esquema *raw* y sobre las cuales se importarán posteriormente los datos de IMDB a partir de los archivos .tsv mencionados previamente, por cada uno de los siete conjuntos de datos
de dicha base se creó un estructura de datos básica con base en lo siguiente:

* Se cambiaron los nombres de las tablas originales pues usaban puntos como separadores, en su lugar se emplearon guiones bajos (por ejemplo, la tabla originalmente denominada como *title.crew* se representó como *title_crew* para Postgres).

* La representación de una tabla de IMDB dentro de Postgres contiene el mismo número de atributos que el correspondiente archivo .tsv, usando las mismas denominaciones pasando a minúsculas los encabezados de los campos pero estableciendo su contenido como tipo texto.

* Cada estructura de datos no contiene reglones, pues se importarán en pasos futuros.

La implementación de este punto corresponde al archivo *create_raw_tables.sql* a través del cual crean siete de estas
estructuras de datos básicas para *raw*, denominadas *title_akas*, *title_basics*, *title_crew*, *title_episode*, *title_principals*, *title_basics* y *name_basics*.

#### 4.4 Carga de conjuntos de datos IMDB a raw

Para importar los archivos .tsv que han sido pre-procesados en la sección precedente (para mayor detalle ver también sección 5.2 y Anexo A), se implementó un procedimiento dentro de Python que realiza dicho acción de manera secuencial, es decir cargando archivo por archivo para evitar problemas de errores de memoria insuficiente o reconocimiento incorrecto del número de columnas por cada renglón.

La función *load_imdb* que realiza lo anterior se localiza el en archivo imdb.py.

Como resultado, las estructuras de datos del esquema raw se llenan con los archivos .tsv correspondientes, donde todos los campos se encuentran como atributos de texto.

#### 4.5 Creación de cleaned

Para crear una versión limpia de IMDB en el esquema cleaned, se desarrollaron una serie de instrucciones que permiten realizar
las siguientes acciones de limpieza de las sietes estructuras. En términos generales, las rutinas implementadas corresponden a lo siguiente:

* Para campos con caracteres "NA", introducidos en la etapa de pre-procesamiento de los archivos .tsv de la base IMDB (ver sección 5.2 y Anexo A), se establecieron valores nulos,
* Para campos con caracteres "?????", introducidos en la etapa de pre-procesamiento de los archivos .tsv de la base IMDB (ver sección 5.2 y Anexo A), se sustituyeron por guiones bajos,
* Trasformación del texto de los campos a minúsculas,
* Se reemplazaron espacios de texto en los campos de las tablas por guiones bajos,
* Se eliminaron acentos (correspondientes a los caracteres "\`" y "\´"),

El detalle específico de uso de estas acciones sobre las siete estructuras de datos de IMBD se refleja en los archivos *to_cleaned1.sql*, *to_cleaned2.sql* y *to_cleaned3.sql*.

Cabe destacar que este proceso, se aprovecha la creación de índices que ayudarán a acelerar la consulta de información entre las tablas para el esquema semantic.

A continuación se resumen la creación de los procesos creados en el código para auxiliarse con diversos índices que permiten acelerar la extracción de tablas desde clean para el esquema semantic:

| proceso*    | tabla      | índices             |
|-------------|------------|---------------------|
| to_cleaned1 | localized  | title               |
| to_cleaned1 | titles     | title type          |
| to_cleaned2 | crew       | title               |
| to_cleaned2 | episodes   | title parent        |
| to_cleaned3 | principals | title category name |
| to_cleaned3 | ratings    | title rating        |
| to_cleaned3 | names      | name                |


\*Nota: En este cuadro proceso se refiere a una función dentro Python que a través de Pyscopg2 manda a ejecutar scripts de sql que reciben el mismo nombre del proceso (es la función se llama to_clean1 manda llamar al archivo to_cleaned1.sql, y así sucesivamente).

#### 4.6 Creación de semantic

Por otra parte, de acuerdo la sección 2, las entidades se refieren a los directores de series y los eventos corresponden a
 si estos dirigen en un determinado periodo de tiempo. Es así que para representar tales estructuras, en términos generales se recurrió a las siguientes acciones:

 **Entidades**
* Dentro del esquema semantic, se efectúa la creación una tabla denominada *entities* que refleja las características estáticas de los directores previamente (ver sección 2):
    * Nombre del director,
    * Año de nacimiento,
    * *Primary profesion*, el conjunto de actividades principales que desarrollar en las obras de entrentenimiento,
    * El valor promedio de sus raitings,

**Eventos**
* Análogamente, dentro del esquema semantic se crea una tabla denominada *events*, que describen si estas personas jugador el rol de en una ventana de tiempo dentro de un capítulo de una serie de cierto perfil:

* el nombre de la serie,
* el año que inició y término de la serie,
* el año del término de cada capítulo,
* el número de la temporada y el episodio correspondiente,
* el género de la serie,
* si la serie es para adultos.

La implementación realizada se refleja en los archivos *to_semantic1.sql*, *to_semantic2.sql* y *to_semantic3.sql* (nota: debido a que se experimentaron problemas de memoria dentro de Vagrant la crear índice, la forma de solventarlo fue dividir el proceso de creación del
esquema en varias subrutinas).

Cabe destacar que en dicho proceso, se aprovecha para la creación de índices que ayudarán a acelerar la consulta de información en etapas posteriores. A continuación se resumen la creación de los procesos en el código para auxiliarse con diversos índices que permiten acelerar la extracción de tablas desde semantic:

| proceso*     | tabla    | índices                        |
|--------------|----------|--------------------------------|
| to_semantic1 | entities | birth primaryprofession        |
| to_semantic2 | events   | startyear genre season episode |


\*Nota: En este cuadro proceso se refiere a una función dentro Python que a través de Pyscopg2 manda a ejecutar scripts de sql que reciben el mismo nombre del proceso (es la función se llama to_semantic1 manda llamar al archivo to_semantic1.sql, y así sucesivamente).

Asimismo, se destaca que la ejecución de las diferentes etapas del pipeline se describirá de manera específica en la sección 6 del presente documento.

### 5. Instalación

Para instalar los componentes necesarios para el proyecto, se consideraron las siguientes etapas:

#### 5.1 Creación de un ambiente Python 3.7.3. con Pyenv

A través de *Pyenv* se crea un entorno virtual basado en Python 3.7.3 (que se denominará *imbd*), que incluirá los paquetes *psycopg2*, *click* y *dynaconf*. Para ello se implementó al archivo Bash denominado *setting_pyenv.sh* que permite ingresar de manera automática a este cuando el usuario se situé con la terminal en el directorio de trabajo.

Es así que para crear tal ambiente con Pyenv, desde el directorio principal del proyecto, el usuario deberá ingresar las siguientes instrucciones:

**Instalación de ambiente virtual: paso 1**

```
cd bin
chmod +x setting_pyenv.sh # Permisos de ejecucion
./setting_pyenv.sh # Ejecuta el script de configuracion para el ambiente virtual
```

#### 5.2 Descarga de datos IMDB y pre-pocesamiento

Por otra parte, siguiendo la documentación de IMDB, las direcciones electrónicas para obtener una versión comprimida (en formato .gz) del conjunto de datos de esta base se encuentran en https://datasets.imdbws.com/, cuyo tamaño agregado es cercano a los 376 MB, por lo cual se decidió crear un archivo de Bash que facilite su descarga de manera automática con la herramienta *curl* y su extracción con la herramienta *gunzip*.

Cabe destacar que, durante el proceso de exploración esta información para consolidar el esquema raw se encontraron algunos problemas para el funcionamiento de Postgres:

i) **Errores de carga por presencia de caracteres "\N" o doble comilla ("):** Según la documentación de IMDB, el carácter "\N" se usa para denotar que cierto campo está ausente o no se encuentra disponible y algunos de los campos contienen texto que incorpora comillas que no abren o cierran por pares, como se haría usualmente en español; en ambos casos, ante la presencia de tales caracteres al importar los archivos .tsv correspondientes hacia Postgres, dicha herramienta arrojó errores en el reconocimiento de reglones con menos columnas de las que realmente definen a las tablas o posibles valores ausentes.

ii) **Errores de carga en archivo que exceden cierto tamaño:** tres de los conjuntos de datos de IMDB exceden los 900 MB, por lo que el equipo en el que se trabajó (Vagrant) se quedaba sin memoria.

A razón de estos puntos, el cuerpo de los archivos .tsv que integran la base IMDB se sometió a un proceso de sustitución de caracteres y  división de ciertos archivos para ejecutar un proceso de carga sin errores (secuencial en el segundo caso) con Postgres, cuyo detalle se describe en el Anexo A al final del presente documento.

En este sentido, la descarga de los datos y el pre-procesamiento para facilitar su importación en Postgres de la etapa raw se logra ejecutando las siguientes instrucciones desde la carpeta de trabajo principal del proyecto:

**Descarga de datos: paso 2**

```
cd /bin
chmod +x preparacion.sh # Otorgamos permisos de ejecucion
./preparacion.sh # Script para descarga de datos IMDB, extraccion y pre-procesamiento para carga a Postgres
```

Como resultado, esta arroja una serie de archivos .tsv dentro de la carpeta /data_imdb necesarios para importar los datos de IMDB hacia raw.

Notas: Aunque el tiempo de ejecución depende de diversos factores, como la velocidad de conexión a Internet, en los ejercicios para el desarrollo del presente proyecto: 1) El tiempo aproximado fue cercano a 22 minutos; 2) el proceso de descompresión de los archivos .gz y pre-procesamiento del cuerpo de los archivos .tsv se llevó a cabo en 6 minutos.

### 6. Ejecución

**Notas:** a) La ejecución del pipeline descrito en la sección 4, se basa en que previamente se han realizado los pasos de instalación descritos a través de la sección 5; y b) A menos que se indique lo contrario, los archivos .sql , que se mencionan en esta sección se encontrarán ubicados en la carpeta *sql*.

Para llevar a cabo pipeline en cuestión, se implementó un archivo en Python denominado *imbd.py* que permite realizar de manera secuencial cada una de sus etapas (es decir, desde 4.1 hasta 4.6) de manera interactiva en la terminal. En términos generales, este archivo funciona a través de lo siguiente:

* Usando los datos del rol creado en la instalación, **rol_IMDB** son usados para comunicarse con Postgres e interacturar con la base que queremos crear juntos con los esquemas correspondientes.
* A través de Python ordenamos ejecutar la etapas descritas en secciones 4.1 a 4.6 del presente documento; de manera específica los
 archivos .sql descritos en el pipeline se ejecutan desde Python hacia Postgres usando psycopg2.

Es necesario señalar que para la ejecución del pipeline, el usuario situarse con la terminal dentro de la carpeta principal del proyecto
En este tenor, a continuación se describirá los pasos necesarios para ejecutar cada etapa del pipeline para IMDB.

#### 6.1 Creación de la base de datos y rol

En línea con lo expresado en la sección 4.1, es necesario crear una base de datos y un rol que tenga permisos de administración sobre la misma.

Esto se realiza a través de una serie de instrucciones dentro del archivo *preparar_base.sql*, el cual se encarga realizar tales acciones creando una base de datos denominada **bd_IMDB**, mientras que el rol será **rol_IMDB** cuyo password es **1234**.

Cabe destacar que para poder indicarle a Python y Postgres esta información en pasos posteriores, dentro de la carpeta *config* se encuentra el archivo *settings.toml* que posee los datos de dicha base y rol, así como la carpeta donde se tienen los datos de IMDB.

En este sentido, para ejecutar esta etapa desde la carpeta de trabajo principal del proyecto se debe ejecutar:

**Creación de base de datos y usuario: Paso 3**

```
cd sql
sudo su postgres # cambiamos el usuario a Postgres
psql -f preparar_base.sql # ejecutamos el archivo que permite la creacion de la base y el rol descritos
exit
```

#### 6.2 Creación de esquemas

La creación los esquemas raw, cleaned y semantic escrita en el numeral 4.2, se efectúa ejecutando la siguiente instrucción:

**Creación de esquemas: Paso 4**

```
python imdb.py create-schemas
```

#### 6.3 Creación de raw tables

En complemento, la creación de raw tables (es decir, la estructuras de datos básicas que servirán para importar los datos en formato .tsv de IMDB), explicadas en el numeral 4.3, se lleva a cabo a través de la instrucción:

**Creación de raw tables: Paso 5**

```
python imdb.py create-raw-tables
```
#### 6.4 Carga del conjuntos de datos IMDB a raw

Posteriormente, la carga de conjuntos de datos IMDB hacia las estructuras de tablas obtenidas en el paso previo, las cuales se abordan en numeral 4.4, se efectúa mediante la instrucción:

**Carga del conjuntos de datos IMDB a raw: Paso 6**

```
python imdb.py load-imdb
```

Notas: Se reitera que aunque el tiempo de ejecución depende de diversos factores en los ejercicios para el desarrollo del presente proyecto el tiempo aproximado de carga desde .tsv hacia raw fue cercano a 11 minutos.

#### 6.5 Creación de cleaned

En adición, la limpieza de la base IMDB desde la fase raw se lleva a cabo mediante los principios descritos en la sección 4.6, a través de las instrucciones:

**Creación de cleaned: Paso 7**

```
python imdb.py to-cleaned1 # primera funcion de limpieza
python imdb.py to-cleaned2 # segunda funcion de limpieza
python imdb.py to-cleaned3 # tercera funcion de limpieza
```

#### 6.6 Creación de semantic

Por lo que hace a la creación del esquema semantic, dicha etapa se realiza con base en los elementos expuestos en la sección 4.6, con base en la instrucción:

**Creación de semantic: Paso 8**

```
python imdb.py to-semantic1 # primera etapa de creacion del esquema
python imdb.py to-semantic2 # segunda etapa de creacion del esquema
python imdb.py to-semantic3 # tercera etapa de creacion del esquema
```

***


### Anexo A

#### A.1 Consideraciones sobre el caracter "\N" en los conjuntos de datos de IMDB

De acuerdo a la documentación de la base, el caracter "\N" se empleó para denotar que campo
está ausente o no se encuentra disponible. Este punto generó que, durante la exploración de los conjuntos
de datos que conforman a la base en cuestión (es decir, los archivos .tsv) para cargarlos hacia Postgres
 como parte de la etapa raw, hubieran errores en el reconocimiento de reglones con menos columnas de las
 que realmente definen a las tablas o posibles valores ausentes.

 Para sortear lo anterior se realizó el siguiente procedimiento: 1) previo a la etapa raw, sobre el cuerpo de cada archivo se realizó
 una sustitución del caracter "\N" por "NA" (ello se implementó a través del archivo Bash denominado *preparacion.sh*, usando *sed*),
y 2) posteriormente en la etapa cleaned se convirtieron en Postgres a valores de tipo "NULL" que se consideran apropiados
para el significado original de la base IMDB (véase el archivo *to_cleaned.sql*).

#### A.2 Consideraciones sobre doble comilla (") en los conjuntos de datos de IMDB

En complemento, durante la fase de exploración de los conjuntos de datos .tsv para su cargar en Postgres, ante la presencia de un caracter comilla (") se encontraron errores de reconocimiento adecuado del número columnas de las tablas o bien de valores ausentes.

Para dar resolver tal incidencia, se recurrió a la siguiente estrategia: 1) previo a la etapa raw, sobre el cuerpo de cada archivo se realizaron sustituciones del caracter de doble comilla ("") por "?????". La implementación de ello se reflejó en el archivo Bash denominado *preparacion.sh*), mientras que  2) en la etapa cleaned se convirtieron a guiones bajos (véase el archivo *to_cleaned.sql*).

#### A.3 Consideraciones sobre el tamaño de los conjuntos de datos IMDB para su carga en raw

Por otra parte, al realizar las carga de los archivos de texto se deben considerar las limitaciones que imponen las
capacidades del equipo para cargar archivos demasiado grandes en la etapa raw. Al respecto, nuevamente durante la exploración de
los conjuntos de datos para su carga en Postgres se encontraron errores de memoria para archivos de cierto peso, como se detalla a continuación:

| # | Archivo | Tamaño | ¿Carga exitosa? |
|---|----------------------|----------|-------|
| 1 | name.basics.tsv | 581.5 Mb | ✔ |
| 2 | title.akas.tsv  | 977.5 Mb | ✖ |
| 3 | title.basics.tsv | 898.7 Mb | ✖ |
| 4 | title.crew.tsv | 342.3 Mb | ✔ |
| 5 | title.episode.tsv | 188.7 Mb | ✔ |
| 6 | title.principals.tsv | 1.6 Gb | ✖ |
| 7 | title.ratings.tsv | 28.2 Mb | ✔ |

**Nota:** ✔ - carga exitosa; ✖ carga fallida

A razón de este punto, se recurrió al comando *split*, pues permite dividir un documento en múltiples archivos que contienen un número determinado de líneas del archivo original, con lo cual se logran versiones más ligeras de archivos de gran peso, y que en el contexto de raw se pueden aprovechar para realizar cargas secuenciales a Postgres.

De manera específica, en el archivo Bash *preparacion.sh* los conjuntos de datos title.akas.tsv, title.basics.tsv y title.principals.tsv,
se procesan con el comando *split* para crear archivos temporales. Tales se aprovechan ver el archivo de Python *imdb.py*
para que Postgres carga por etapas (véase la función *load_imdb*).
