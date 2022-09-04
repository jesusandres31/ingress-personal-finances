# ETL with Sheet.js

## Execute

### 1) Setup database

- create Postgres database called `ingress`
- import database (on windows, from `.db/` execute `cat ./ingress.sql | psql -U postgres -d ingress`)

### 2) Setup rest client collection

- install Insomnia Rest Client
- import colection saved in `./insomnia`

### 3) Run dev server

- npm i
- npm run dev
