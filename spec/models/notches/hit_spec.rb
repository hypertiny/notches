require 'spec_helper'

describe Notches::Hit do
  describe "validations" do
    let(:hit) do
      Notches::Hit.new(
        :url => Notches::URL.new(:url => "/posts"),
        :session => Notches::Session.new(:session_id => '1234'),
        :ip => Notches::IP.new(:ip => '209.85.143.94')
      )
    end

    its "valid with valid attributes" do
      hit.should be_valid
    end

    it "requires an ip" do
      hit.ip = nil
      hit.should have(1).error_on(:ip)
    end

    it "requires a session" do
      hit.session = nil
      hit.should have(1).error_on(:session)
    end

    it "requires a " do
      hit.url = nil
      hit.should have(1).error_on(:url)
    end

    it "does not validate if its IP's ip blank" do
      hit.ip = Notches::IP.new(:ip => '')
      hit.should have(1).error_on(:ip)
    end

    it "does not validate if its Session's session_id is blank" do
      hit.session = Notches::Session.new(:session_id => '')
      hit.should have(1).error_on(:session)
    end

    it "does not validate if its URL's url is blank" do
      hit.url = Notches::URL.new(:url => '')
      hit.should have(1).error_on(:url)
    end
  end

  describe ".log" do

    context "with valid attributes" do
      let(:today) { Date.today }
      let(:now) { Time.now }
      before do
        Date.stub(:today => today)
        Time.stub(:now => now)
      end

      it "creates a hit for today and current time with those attributes" do
        Notches::Hit.log({
          :url => '/posts',
          :user_agent => 'FeedBurner/1.0',
          :session_id => '1',
          :ip => '0.0.0.1'
        })
        hit = Notches::Hit.first
        hit.should be_present
        hit.url.url.should == '/posts'
        hit.session.session_id.should == '1'
        hit.ip.ip.should == '0.0.0.1'
        hit.date.date.should == today
        hit.time.time.strftime('%H:%M:%S').should == now.strftime('%H:%M:%S')
        hit.user_agent.user_agent.should == 'FeedBurner/1.0'
        hit.user_agent.user_agent_md5.should == Digest::MD5.hexdigest('FeedBurner/1.0')
      end
    end

    let(:existing_hit) { 
      Notches::Hit.log(
        :url => "/posts/1",
        :user_agent => 'FeedBurner/1.0',
        :session_id => '1',
        :ip => '0.0.0.1'
      )
    }

    it "does not create a new IP record if there's a record for that IP already" do
      hit = Notches::Hit.log(
        :url => "/posts/2",
        :session_id => '2',
        :ip => existing_hit.ip.ip
      )
      hit.ip.id.should == existing_hit.ip.id
    end

    it "does not create a new URL record if there's a record for that URL already" do
      hit = Notches::Hit.log(
        :url => existing_hit.url.url,
        :session_id => '2',
        :ip => '0.0.0.2'
      )
      hit.url.id.should == existing_hit.url.id
    end

    it "does not create a new Session record there's a record for that session id already" do
      hit = Notches::Hit.log(
        :url => "/posts/2",
        :session_id => existing_hit.session.session_id,
        :ip => '0.0.0.2'
      )
      hit.session.id.should == existing_hit.session.id
    end

    it "does not create a new Date record there's a record for that Date already" do
      hit = Notches::Hit.log(
        :url => '/posts/2',
        :session_id => '2',
        :ip => '0.0.0.2'
      )
      hit.date.id.should == existing_hit.date.id
    end

    it "does not create a new Time record there's a record for that Time already" do
      Time.stub(:now => existing_hit.time.time)
      hit = Notches::Hit.log(
        :url => '/posts/2',
        :session_id => '2',
        :ip => '0.0.0.2'
      )
      hit.time.id.should == existing_hit.time.id
    end

    it "does not create a new UserAgent record if there's a record for that UserAgent already" do
      hit = Notches::Hit.log(
        :url => '/post/2',
        :user_agent => 'FeedBurner/1.0',
        :session_id => '2',
        :ip => '0.0.0.2'
      )
      hit.user_agent.id.should == existing_hit.user_agent.id
    end

    context "a hit with the same url, session, ip, date and time exists already" do
      it "does not log the hit" do
        Date.stub(:today => existing_hit.date.date)
        Time.stub(:now => existing_hit.time.time)
        expect {
          hit = Notches::Hit.log(
            :url => existing_hit.url.url,
            :user_agent => 'FeedBurner/1.0',
            :session_id => existing_hit.session.session_id,
            :ip => existing_hit.ip.ip
          )
        }.to_not change { Notches::Hit.count }
      end
    end
  end
end
