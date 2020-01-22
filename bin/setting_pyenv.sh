# Nos situamos en el directorio principal

cd ..

# Instala version Python-3.7.3
pyenv install 3.7.3

# Crea el ambiente virtual Imbd basado en Python 3.7.3
pyenv virtualenv 3.7.3 Imbd

# Crea un archivo de texto que facilita activacion automatica del ambiente
echo "Imbd" > .python-version

# Instalmos diferentes paquetes para el ambiente virtual
pip install psycopg2 click dynaconf

