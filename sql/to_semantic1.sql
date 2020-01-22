
do language plpgsql $$ declare
    exc_message text;
    exc_context text;
    exc_detail text;
begin

  do $semantic$ begin

  set search_path = semantic, public;
  
  /******************* entities *******************/

  raise notice 'populating entities';
  drop table if exists semantic.entities;
  
  create table if not exists semantic.entities as (
	SELECT DISTINCT
		names.primaryname,
		names.birth,
		names.primaryprofession,
		AVG(ratings.rating) ratingavg
	FROM
		cleaned.titles titles,
		cleaned.episodes episodes,
		cleaned.ratings ratings,
		cleaned.crew crew,
		cleaned.names names
	WHERE
		type = 'tvseries'
			AND episodes.parent = titles.title
			AND ratings.title = episodes.title
			AND crew.title = episodes.title
			AND names.name = crew.director
	GROUP BY names.primaryname , names.birth , names.primaryprofession
  );
  
  create index semantic_entities_birth_ix on semantic.entities(birth);
  create index semantic_entities_primaryprofession_ix on semantic.entities(primaryprofession);
  

  end $semantic$;

  set search_path = semantic, public;
exception when others then
    get stacked diagnostics exc_message = message_text;
    get stacked diagnostics exc_context = pg_exception_context;
    get stacked diagnostics exc_detail = pg_exception_detail;
    raise exception E'\n------\n%\n%\n------\n\nCONTEXT:\n%\n', exc_message, exc_detail, exc_context;
end $$;
