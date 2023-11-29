## Problem statement

> **It's dinner time ! Create an application that helps users find the most relevant recipes that they can prepare with the ingredients that they have at home**

Functional Requirements:
- User can create an account
- User can login
- User can search Recipes based on name.
- User can search Recipes based on ingredients.
- User can search Recipes based on their cooking time.
- User can favorite(like) a Recipe (optional)
- User can view al his / her favorite recipes (optional)
- User can search for Recipes on the internet when the DB does not yield results
    - Search for recommendations using ChatGPT
    - Search for recommendations using the Scraper

Data 
- Integrate the Recipe Scraper into our codebase and run it in a rake task every night that creates a JSON.
- Load the JSON into the DB every night using a rake task.

UI
- We first do a search and load from the DB.
- Results are sorted based on their match. (Maybe use search scope in associated search for PG search https://github.com/Casecommons/pg_search)
- If there are no results ask if the user wants to search the internet.
- If the user reaches the end of the result list, ask if the user wants to search the internet. (ChatGPT)
- User can sort recipes based on their cooking time.

Technical setup / Non functional requirements
- Rails application (Use a LW rails template)
- Use react components in the Rails app to build the UI.
- Hosting on fly.io.
- Gems to use:
    - PGanalayze (basic DB analysis / pg_query)
    - Datadog (full scale monitoring)
    - Rubocop (✅)
    - Flipper (✅)
    - React-rails (✅)
    - Devise (✅)
    - PG search (✅)
    - Bullet (analyze slow queries / unused includes etc.) (✅)


TODO:
- Look into www.fly.io (sort of Heroku) - DONE
- Finish functional requirements - DONE
- DB design (use LW tool to create Normalized DB design.)(https://kitt.lewagon.com/db/116190) - DONE
    - Contemplated using jsonb column for ingredients but as I expected queries on these columns are usually quite slow.
    - Contemplated splitting the ingredient description into a quantity and a name, but out of scope for now.
    - The cuisine property seems mostly empty in the JSON data. Adding it for completeness though (could/should be external table since IMO a dish can belong to multiple Cuisines')
    - Contemplated having a n:n relationship betweem recipes and ingredients, but given the current scope this is unneccesary and makes the DB import complicated to be done efficiently.
- Wrap head around non-functional requirements (Security/Scalibilty/Availability) Fly.io / Rails / Webpack / Asset Pipeline - DONE
- Setup Rails App Backend - DONE
- Add/Removed unused Gems - DONE
- Create models / DB structure 
- Add some unit tests
- Build Basic UI for logging in / and searching
- Build Recipe controller w/ filtered index method
- Build Search Service
- Use React inside the rails app for UI / FE.
    - How to send the data from the controller to the view ? -> view_helper react_component
- How can I implement a feature flag using flipper?
(- Throw in a docker container?)



## Objective

Deliver an application prototype to answer the above problem statement.

By prototype, we mean:
- something usable, yet as simple as possible
- UI / design is not important
- we do not expect features which are outside the basic scope of the problem

We expect to use this prototype as a starting point to discuss current implenentation details, as well as ideas for improvement.

#### Tech must-haves
- [ ] MySQL / PostgreSQL or any other MySQL-compatible database.
- [ ] A backend application which responds to queries
- [ ] A web interface (can be VERY simple)
- [ ] Ruby on Rails (if you're not familiar with Ruby on Rails, use something you're familiar with)

#### Bonus points
- [ ] React
- [ ] Application is hosted on fly.io

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
