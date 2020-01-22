
do language plpgsql $$ declare
    exc_message text;
    exc_context text;
    exc_detail text;
begin

  do $cleaned$ begin

   set search_path = cleaned, public;




/*********** Origen:title_crew Destino:crew ***********/
  raise notice 'populating crew';
  drop table if exists cleaned.crew  cascade;
  
  create table cleaned.crew as (
    select
      tconst::varchar as title,
      case directors
          when 'NA' then null::varchar
		    else directors::varchar end as director,
      case writers
          when 'NA' then null::varchar
		    else writers::varchar end as writer

    from raw.title_crew);

    create index cleaned_crew_title_ix on cleaned.crew (title);


/*********** Origen:title_episodes Destino:episodes ***********/
    raise notice 'populating episodes';
    drop table if exists cleaned.episodes cascade;
      
      create table cleaned.episodes as (
        select
          tconst::varchar as title,
          lower(parenttconst)::varchar as parent,
          case seasonnumber
          when 'NA' then null::integer
		    else seasonnumber::integer end as season,
          case episodenumber
          when 'NA' then null::integer
		    else episodenumber::integer end as episode

        from raw.title_episode);

    create index cleaned_episodes_title_ix on cleaned.episodes (title);
	create index cleaned_episodes_parent_ix on cleaned.episodes (parent);



  end $cleaned$;

exception when others then
   get stacked diagnostics exc_message = message_text;
    get stacked diagnostics exc_context = pg_exception_context;
    get stacked diagnostics exc_detail = pg_exception_detail;
    raise exception E'\n------\n%\n%\n------\n\nCONTEXT:\n%\n', exc_message, exc_detail, exc_context;
end $$;
