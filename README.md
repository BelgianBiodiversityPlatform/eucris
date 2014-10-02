# EUCRIS
## Summary
This web application gives access to BiodivERsA database.

The BiodivERsA database is a Current Research Information System(CRIS) that compiles information about past and current funding programs on biodiversity in Europe (including thematic and blue sky programs, grants, fellowships and studentships), research organisations, and project leading researchers active in biodiversity research.

## Functionalities
The database complies to the CERIF standard (Common European Research Information Format).

Once registered, users can query the database objects:

* Funding Programme (i.e. organizational grouping of research projects or activities with a common funding and steering mechanism)
* Funding organisation (i.e. public, private or charitable organisation funding research open to external competition)
* Project (i.e. funded units within or outside a research program which has defined goals, objectives and timeframe)
* Research organisation (universities or research institutes)
* Person (project managers and researchers)
Search results can be downloaded in text (CSV) format.
Database update is currently not supported by this web application. 

see [ our hosted website](http://www.biodiversa.org/database/) for more.

## Tools
This web application relies on the following tools:

* [Ruby Language](https://www.ruby-lang.org/fr) (1.9.3)
* [Ruby on Rails framework](http://rubyonrails.org/) (3.0.9)
* [Bootstrap](http://getbootstrap.com/) (2.0.4)
* [PostgreSQL](http://www.postgresql.org/)

## Gems
This web application also requires the following Ruby gems:

* *pg* access PostgreSQL database
* *fastercsv* CSV library 
* *kaminari* paginator library

