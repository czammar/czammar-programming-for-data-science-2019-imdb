
do language plpgsql $$ declare
    exc_message text;
    exc_context text;
    exc_detail text;
begin

  do $cleaned$ begin

   set search_path = cleaned, public;


/*********** Origen:title_akas Destino:localized ***********/

/*
En title únicamente se convierte la información a minúsculas, se reemplaza ????? por _ . No se lleva a cabo ninguna otra acción debido a que este campo incluye el título de las películas en diversos idiomas.

En types se transforma la información a minúsculas y se reemplaza '/x02' por ',' para indicar la separación entre los posibles valores de este campo
*/

  raise notice 'populating localized';
  drop table if exists cleaned.localized  cascade;
  
  create table cleaned.localized as (
    select
      titleid::varchar as title,
      ordering::int as ordering,
      replace(lower(title),'?????','_')::varchar as titlename,
      case region
          when 'NA' then null::varchar
		    else lower(region)::varchar end as region,
      case language
          when 'NA' then null::varchar
		    else lower(language)::varchar end as language,
      case types
          when 'NA' then null::varchar
		    else types::varchar end as type,
	  case attributes
          when 'NA' then null::varchar
		    else replace(lower(attributes),' ','_')::varchar end as attribute,
	  case isoriginaltitle
		when '0' then 'f'::boolean
		when '1' then 't'::boolean
		when 'NA' then null::boolean
		else null::boolean end as isoriginal

    from raw.title_akas);
    
    create index cleaned_localized_title_ix on cleaned.localized (title);


/*********** Origen:title_basics Destino:titles ***********/
  raise notice 'populating titles';
  drop table if exists cleaned.titles  cascade;
  
  create table cleaned.titles as (
    select
      tconst::varchar as title,
      lower(titletype)::varchar as type,
      replace(lower(primarytitle),' ','_')::varchar as primary,
      lower(originaltitle)::varchar as original,
	  case isadult
		when '0' then 'f'::boolean
		when '1' then 't'::boolean
		else null::boolean end as adult,
	  case startyear
          when 'NA' then null::int
		    else lower(startyear)::int end as startyear,
	  case endyear
          when 'NA' then null::int
		    else lower(endyear)::int end as endyear,
	  case runtimeminutes
          when 'NA' then null::int
		    else lower(runtimeminutes)::int end as runtime,
	  lower(genres)::varchar as genre
    from raw.title_basics);
    
    create index cleaned_titles_title_ix on cleaned.titles (title);
    create index cleaned_titles_type_ix on cleaned.titles (type);





  end $cleaned$;

exception when others then
   get stacked diagnostics exc_message = message_text;
    get stacked diagnostics exc_context = pg_exception_context;
    get stacked diagnostics exc_detail = pg_exception_detail;
    raise exception E'\n------\n%\n%\n------\n\nCONTEXT:\n%\n', exc_message, exc_detail, exc_context;
end $$;
