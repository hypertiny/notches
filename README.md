Notches
-------

A Rails Engine for tracking your web traffic.

Installation
------------

Add this to your Gemfile and run the `bundle` command.

   gem 'notches', '~> 0.1.0'

And then install and run the necessary migrations.

   rake notches_engine:install:migrations
   rake db:migrate

Mount your engine at your desired location in `config/routes.rb`.

   mount Notches::Engine => '/notches'

Finally to start recording hits include the notch pixel image at the bottom of your views.

   <%= image_tag "/notches/hits/new.gif?url=#{request.url}" %>

Counting hits
-------------

For a URL:

   Notches::Hit.joins(:url).where('url like ?', '/posts').count

For an IP:

   Notches::Hit.joins(:ip).where('ip = ?', '127.0.0.1').count

For a session id:

   Notches::Hit.joins(:session).where('session_id = ?', 'abcd').count

For a date:

   Notches::Hit.joins(:date).where('date = ?', Date.today).count

For a particular time of day:

   Notches::Hit.joins(:time).where('time between ?', '09:00:00', '17:00:00').count

To get a better idea of how Notches is setup check out the
[Notches::Hit](http://github.com/hypertiny/notches/app/models/notches/hit.rb) model.
