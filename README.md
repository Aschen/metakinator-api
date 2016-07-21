# Metakinator

Metakinator is a game based on [Akinator](http://en.akinator.com/).  
We took the main concept which is to guess characters relying on a set of question/answers.  
In this version we have multiple knowledge base and you can import or export new one as you want.  

This repository is about the API part of the game. If you want to see the Android application this is [here](http://github.com).  

This application is build with Ruby-On-Rails.

## How to

  - `bundle install` : install dependencies
  - `rake db:create db:migrate` : initialize database (PostgreSQL and you may need to edit `config/database.yml` with your credential)
  - `rails server` : start the server
  - Go to `http://localhost:3000` to see the backoffice
  - You can import knowledge base, they are in the repository (`sport.csv`, `southparc.csv`, `pokemon.csv`)

## Features

  - Import and export knowledge base in CSV and Excel format
  - Exported knowledge base are [Weka](http://www.cs.waikato.ac.nz/ml/weka/) (Data mining and machine learning software) compatible
  - Live edition of knowledge base through the back-office
  - Choose the next question based on entropy calculation
  - Provide JSON API to communicate with the Android application
