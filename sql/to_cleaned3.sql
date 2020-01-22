
do language plpgsql $$ declare
    exc_message text;
    exc_context text;
    exc_detail text;
begin

  do $cleaned$ begin

   set search_path = cleaned, public;




/*********** Origen:title_principals Destino:principals ***********/

    raise notice 'populating principals';
    drop table if exists cleaned.principals cascade;
      
      create table cleaned.principals as (
        select
          tconst::varchar as title,
          ordering::int as ordering,
          nconst::varchar as name,
          category::varchar as category,
          case job
          when 'NA' then null::varchar
		    else replace(replace(lower(job),'?????',''),' ','_')::varchar end as job,
          case characters
          when 'NA' then null::varchar
		    else replace(replace(replace(replace(lower(characters),'?????',''),'[',''),']',''),' ','_')::varchar end as character


        from raw.title_principals);
        
    create index cleaned_principals_title_ix on cleaned.principals (title);
	create index cleaned_principals_category_ix on cleaned.principals (category);


/*********** Origen:title_ratings Destino:ratings ***********/

    raise notice 'populating ratings';
    drop table if exists cleaned.ratings cascade;
      
      create table cleaned.ratings as (
        select
          tconst::varchar as title,
          averagerating::float as rating,
          numvotes::int as votes

        from raw.title_ratings);
        
    create index cleaned_ratings_title_ix on cleaned.ratings (title);
	create index cleaned_ratings_averagerating_ix on cleaned.ratings (rating);


/*********** Origen:name_basics Destino:names ***********/

/* primaryname se reemplazan los espacios por guión bajo 

primaryprofession, se conserva la coma que traía la base original para tener en cuenta que la coma separa los elementos de este campo

knownfortitle, se conserva la coma que traía la base original para tener en cuenta que la coma separa los elementos de este campo


*/

    raise notice 'populating names';
    drop table if exists cleaned.names cascade;
      
      create table cleaned.names as (
        select
          nconst::varchar as name,
          replace(lower(primaryname),' ','_')::varchar as primaryname, 
          case birthyear
          when 'NA' then null::int
		    else birthyear::int end as birth,
          case deathyear
          when 'NA' then null::int
		    else deathyear::int end as death,
          lower(primaryprofession)::varchar as primaryprofession, 
          case knownfortitles
          when 'NA' then null::varchar
		    else knownfortitles::varchar end as knownfor
        from raw.name_basics);
        
    create index cleaned_names_name_ix on cleaned.names (name);


  end $cleaned$;

exception when others then
   get stacked diagnostics exc_message = message_text;
    get stacked diagnostics exc_context = pg_exception_context;
    get stacked diagnostics exc_detail = pg_exception_detail;
    raise exception E'\n------\n%\n%\n------\n\nCONTEXT:\n%\n', exc_message, exc_detail, exc_context;
end $$;
