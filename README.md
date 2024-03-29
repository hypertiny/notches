Notches
-------

A Rails Engine for tracking your web traffic or other events.

Installation
------------

Add this to your Gemfile and run the `bundle` command.

    gem 'notches', '~> 0.7.1'

And then install and run the necessary migrations.

    rake notches:install:migrations
    rake db:migrate

Mount your engine at your desired location in `config/routes.rb`.

    mount Notches::Engine => '/notches'

Recording hits
--------------

To record hits include the notch pixel image at the bottom of your views.

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

Or a user agent:

    Notches::Hit.joins(:user_agent).where('user_agent like ?', '%Mobile%').count

To get a better idea of how Notches is setup check out the
[Notches::Hit](http://github.com/hypertiny/notches/blob/master/app/models/notches/hit.rb) model.

Recording events
----------------

To record events make the following call:

    Notches::Event.log(name: 'An event')

Events can have one or two optional scopes:

    Notches::Event.log(name: 'An event', scope: 'A person')
    Notches::Event.log(name: 'An event', scope: ['A person', 'An object'])

Counting events
-------------

For a name:

    Notches::Event.joins(:name).where('name = ?', 'An event').count

For a name and scope:

    Notches::Event.joins(:name, :scope).where(
      'name = ? and scopes.primary = ? and scopes.secondary = ?',
      'An event', 'A person', 'An object'
    ).count
