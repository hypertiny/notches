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

    it "valid with valid attributes" do
      expect(hit).to be_valid
    end

    it "requires an ip" do
      hit.ip = nil
      hit.valid?
      expect(hit.errors[:ip]).to eq(["can't be blank"])
    end

    it "requires a session" do
      hit.session = nil
      hit.valid?
      expect(hit.errors[:session]).to eq(["can't be blank"])
    end

    it "requires a url" do
      hit.url = nil
      hit.valid?
      expect(hit.errors[:url]).to eq(["can't be blank"])
    end

    it "does not validate if its IP's ip blank" do
      hit.ip = Notches::IP.new(:ip => "")
      hit.valid?
      expect(hit.errors[:ip]).to eq(["is invalid"])
    end

    it "does not validate if its Session's session_id is blank" do
      hit.session = Notches::Session.new(:session_id => '')
      hit.valid?
      expect(hit.errors[:session]).to eq(["is invalid"])
    end

    it "does not validate if its URL's url is blank" do
      hit.url = Notches::URL.new(:url => '')
      hit.valid?
      expect(hit.errors[:url]).to eq(["is invalid"])
    end
  end

  describe ".log" do

    context "with valid attributes" do
      let(:now) { Time.zone.now }
      before do
        allow(Time).to receive_message_chain(:zone, :now).and_return(now)
      end

      it "creates a hit for today and current time with those attributes" do
        Notches::Hit.log({
          :url => '/posts',
          :user_agent => 'FeedBurner/1.0',
          :session_id => '1',
          :ip => '0.0.0.1'
        })
        hit = Notches::Hit.first
        expect(hit).to be_present
        expect(hit.url.url).to eq('/posts')
        expect(hit.session.session_id).to eq('1')
        expect(hit.ip.ip).to eq('0.0.0.1')
        expect(hit.date.date).to eq(now.to_date)
        expect(hit.time.time.strftime('%H:%M:%S')).to eq(now.strftime('%H:%M:%S'))
        expect(hit.user_agent.user_agent).to eq('FeedBurner/1.0')
        expect(hit.user_agent.user_agent_md5).to eq(Digest::MD5.hexdigest('FeedBurner/1.0'))
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
      expect(hit.ip.id).to eq(existing_hit.ip.id)
    end

    it "does not create a new URL record if there's a record for that URL already" do
      hit = Notches::Hit.log(
        :url => existing_hit.url.url,
        :session_id => '2',
        :ip => '0.0.0.2'
      )
      expect(hit.url.id).to eq(existing_hit.url.id)
    end

    it "does not create a new Session record there's a record for that session id already" do
      hit = Notches::Hit.log(
        :url => "/posts/2",
        :session_id => existing_hit.session.session_id,
        :ip => '0.0.0.2'
      )
      expect(hit.session.id).to eq(existing_hit.session.id)
    end

    it "does not create a new Date record there's a record for that Date already" do
      hit = Notches::Hit.log(
        :url => '/posts/2',
        :session_id => '2',
        :ip => '0.0.0.2'
      )
      expect(hit.date.id).to eq(existing_hit.date.id)
    end

    it "does not create a new Time record if there's a record for that Time already even if date was different" do
      existing_hit.time.update_attributes!(time: Time.parse('2016-08-03 14:15:59 UTC'))
      allow(Time).to receive(:now).and_return(Time.parse('2016-08-04 14:15:59 UTC'))
      hit = Notches::Hit.log(
        :url => '/posts/2',
        :session_id => '2',
        :ip => '0.0.0.2'
      )
      expect(hit.time.id).to eq(existing_hit.time.id)
    end

    it "does not create a new UserAgent record if there's a record for that UserAgent already" do
      hit = Notches::Hit.log(
        :url => '/post/2',
        :user_agent => 'FeedBurner/1.0',
        :session_id => '2',
        :ip => '0.0.0.2'
      )
      expect(hit.user_agent.id).to eq(existing_hit.user_agent.id)
    end

    context "a hit with the same url, session, ip, date and time exists already" do
      it "does not log the hit" do
        allow(Time).to receive_message_chain(:zone, :now).and_return(existing_hit.time.time)
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

    context "when given a user id" do
      it "attaches the user id to the session" do
        hit = Notches::Hit.log({
          :url => '/posts',
          :user_agent => 'FeedBurner/1.0',
          :user_id    => 7,
          :session_id => '1',
          :ip => '0.0.0.1'
        })
        expect(Notches::UserSession.exists?(notches_session_id: hit.session.id, user_id: 7)).to eq(true)
      end
    end
  end
end
