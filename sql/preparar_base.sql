-------------------------- Script para crear la base y rol necesario

----Eliminamos la base de datos en caso de existir
drop database if exists bd_imdb;

----Crear la base de datos:
create database bd_imdb;

----Eliminamos el rol en caso de existir:
drop role if exists rol_imdb;

----Crear el rol:
create role rol_imdb;

----Asignarle el password:
alter role rol_imdb with encrypted password '1234';
alter role rol_imdb with login;

----Asignarle permisos:
grant all privileges on database bd_imdb to rol_imdb;

----Asignarle permisos: (la línea anterior no se los está dando por alguna extraña razón)
alter database bd_imdb owner to rol_imdb;
