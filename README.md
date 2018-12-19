# Volders

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Update Config file with usrname and password for the database
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


# Run Test

You run the test suits by simply typing ``` mix test ```

# Decisions 
My first decision was Authentication do I use 3rd party library like Guardian that have JWT solution or I simply roll my own authentication using phoenix sessions, comeonin and bycrypt, I went with the latter as the app is simple enough and web only.


My second and biggest decision was regarding Vendors and Categories, logically speaking vendor and category have many to many relationships where you create 3 tables Vendor with name & id, Category with name & id and vendors_categories where it contains vendor_id & category_id columns, all will be under one Context named like Agreement/UserContract

During creating contract page we need to dynamically fill the categories on vendor select by calling ``fetch("/api/vendor/1")`` in the client side where we have a sperate controller for vendor in the backend that answer with json containing vendor categories

then again I realized I would probably would have to create separate admin dashboard with it own routes/controllers because we can't allow the user to add vendors and categories. then If I created admin then I need to expand user model to support roles and realized I'm getting out of scope.

so Instead I decided to simply hardcode vendor and categories. 




