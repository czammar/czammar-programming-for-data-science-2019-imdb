
do language plpgsql $$ declare
    exc_message text;
    exc_context text;
    exc_detail text;
begin

  do $semantic$ begin

  set search_path = semantic, public;
  
  /******************* events *******************/
  
  raise notice 'defining event types';
  drop table if exists semantic.events;

  create table if not exists semantic.events as (
  SELECT DISTINCT
		names.primaryname,
        titles.primary,
        titles.startyear,
        titles.endyear,
        titles.runtime,
        titles.genre,
        titles.adult,
        episodes.season,
        episodes.episode,
        ratings.rating
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
  );
  
  create index semantic_events_startyear_ix on semantic.events(startyear);
  create index semantic_events_genre_ix on semantic.events(genre);
  create index semantic_events_season_ix on semantic.events(season);
  create index semantic_events_episode_ix on semantic.events(episode);

  end $semantic$;

  set search_path = semantic, public;
exception when others then
    get stacked diagnostics exc_message = message_text;
    get stacked diagnostics exc_context = pg_exception_context;
    get stacked diagnostics exc_detail = pg_exception_detail;
    raise exception E'\n------\n%\n%\n------\n\nCONTEXT:\n%\n', exc_message, exc_detail, exc_context;
end $$;
