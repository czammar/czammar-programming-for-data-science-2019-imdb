
do language plpgsql $$ declare
    exc_message text;
    exc_context text;
    exc_detail text;
begin

  do $semantic$ begin

  set search_path = semantic, public;
  
  /******************* indexes *******************/
  
 drop index if exists semantic_entities_birth_ix; 
 create index semantic_entities_birth_ix on semantic.entities(birth);

 drop index if exists semantic_entities_primaryprofession_ix;
 create index semantic_entities_primaryprofession_ix on semantic.entities(primaryprofession);
  
  drop index if exists semantic_events_startyear_ix;
  create index semantic_events_startyear_ix on semantic.events(startyear);

 drop index if exists semantic_events_genre_ix; 
 create index semantic_events_genre_ix on semantic.events(genre);

  drop index if exists semantic_events_season_ix;
  create index semantic_events_season_ix on semantic.events(season);
  
  drop index if exists semantic_events_episode_ix;
  create index semantic_events_episode_ix on semantic.events(episode);

  end $semantic$;

  set search_path = semantic, public;
exception when others then
    get stacked diagnostics exc_message = message_text;
    get stacked diagnostics exc_context = pg_exception_context;
    get stacked diagnostics exc_detail = pg_exception_detail;
    raise exception E'\n------\n%\n%\n------\n\nCONTEXT:\n%\n', exc_message, exc_detail, exc_context;
end $$;
