# Recipe Roundabout

Please see [this notion](https://industrious-sale-74e.notion.site/Recipe-Roundabout-simple-tech-spec-3065f0946e72471ea7062532c7410fe3) for context on how I approached the below problem statement.

## Instructions

Welcome!

Using this application we can search Recipes based ingredients, and subsequently favorite them.

After cloning the application and navigating to the folder run:

```
$ bundle install
$ yarn install
$ rails db:setup db:seed
```

In order to run a local dev server run the following:
```
$ rails s
```

The application is hosted and deployed on www.fly.io and can be found [here](https://recipe-roundabout.fly.dev/).


## Problem statement
> **It's dinner time ! Create an application that helps users find the most relevant recipes that they can prepare with the ingredients that they have at home**

## Objective
Deliver an application prototype to answer the above problem statement.

By prototype, we mean:
- something usable, yet as simple as possible
- UI / design is not important
- we do not expect features which are outside the basic scope of the problem

We expect to use this prototype as a starting point to discuss current implenentation details, as well as ideas for improvement.

#### Tech must-haves
- [X] MySQL / PostgreSQL or any other MySQL-compatible database.
- [X] A backend application which responds to queries
- [X] A web interface (can be VERY simple)
- [X] Ruby on Rails (if you're not familiar with Ruby on Rails, use something you're familiar with)

#### Bonus points
- [X] React
- [X] Application is hosted on fly.io

## Data
We provide two datasets to choose from:
- [french-language recipes](https://pennylane-interviewing-assets-20220328.s3.eu-west-1.amazonaws.com/recipes-fr.json.gz) scraped from www.marmiton.org with [python-marmiton](https://github.com/remaudcorentin-dev/python-marmiton)
- [english-language recipes](https://pennylane-interviewing-assets-20220328.s3.eu-west-1.amazonaws.com/recipes-en.json.gz) scraped from www.allrecipes.com with [recipe-scrapers](https://githubingredients.com/hhursev/recipe-scrapers)

Download it with this command if the above link doesn't work:
```shell
wget https://pennylane-interviewing-assets-20220328.s3.eu-west-1.amazonaws.com/recipes-en.json.gz && gzip -dc recipes-en.json.gz > recipes-en.json
```

## Deliverable
- the 2-3 user stories which the application implements
- the codebase : in a git repo (share it with @quentindemetz @tdeo @soyoh @lucasbonin @sforsell @clemalfroy @dmilon @pointcom @evangelos-fotis @thecodehunter)
- the database structure
- the application, running on fly.io or on a personal server.
- please submit links to the GitHub repo and the hosted application [via this form](https://forms.gle/siH7Rezuq2V1mUJGA) and if you're on Mac, make sure your browser has permission to share the screen



#### TODO
Points of interest:
- Make sure the search results are more relevant based on keywords, less fuzzy.
  - More relevant - added weight to title - why does pita bread yield Peppy's Pita Bread as a first result, and not Pita Bread, which is a direct hit.

  - Less fuzzy - added weight to title
- Make sure the search is not too strict.
  - Not sure about this; should adding more terms yield more results?
    - flour salt buttermilk pickle juice lard bacon eggs
- Check use of indexes / preload data / cache data
  
Sofia comments / questions:
  - How to make sure the application can handle more load?
  Pagination
  Caching (redis)
  ElasticSearch (or even algolia)
  Query Tuning


Email questions / answers

- First thing is I wondered is If you would have preferred me to use a self built SQL query instead of using PG search, and if so, do you think that during a potential next interview I should write a custom query or is using and tweaking PG search also acceptable.
- 1. On our side we don't really care if it's pure SQL or if you're using pg_search, but we do expect you to be able to explain how it works and if there are any limitations to whichever solution you use.

Rebuilt using pure SQL.
- Benefits: 
  Full customizability and full control.
- Drawbacks: 
  First iteration seems to be less performant than pgsearch. 240ms vs 408ms.
  More (complicated) code means more maintenance and tech debt.







- Secondly my answer to your question regarding the method “set_favorite_on_recipes” might have been a bit defensive, instead of listening to your improvement I explained why I wrote it that way.  Do you think I should make use of a “join” statement instead to load the data from DB differently, or is the current implementation which updates the data in memory sufficient in a potential next round?
- 2. I don't think you need to worry about it, being aware in this case is enough :) 


- And last, do you think I should consider performance improvements for a potential next round? (Check use of indexes, measure query times, etc.)
- 3. Performance improvements are always a plus and we'd be curious to see what you come up with and the ideas you explore.
- Use PGanalyze / Datadog to check query times, query performance and tweak queries accordingly.
- How to split up the DB by using horizontal sharding?
- Main write DB and multiple Slave Read DB
- Cache the query words under a key in redis, with the ids of the recipes as the value.
- Cache the objects in Redis
- Need to consider Cache invalidation, how and when to invalidate keys / objects.
- Connection pooling, but only neccesarry to improve performance when we get close a max # of connections hitting the DB. (Is this done efficiently )
- Enhance observability through Datadog or similar service. Run load tests using locust and see where the thresholds are. Install alarms at 50 and 75% of these thresholds.




<!-- Inou -->
- Ingredient 
