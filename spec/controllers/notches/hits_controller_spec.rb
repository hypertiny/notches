require 'spec_helper'

describe Notches::HitsController do
  describe "#new" do
    it "returns an image" do
      get :new, :url => '/posts', :format => 'gif'

      response.headers["Content-Type"].should == 'image/gif'
    end

    it "logs the hit" do
      @request.env['HTTP_USER_AGENT'] = 'FeedBurner/1.0'
      @request.stub(:remote_ip => '234.101.82.14')
      @request.stub(:session_options => { :id => 'abcd' })

      get :new, :url => '/posts', :user_id => 7, :format => 'gif'

      Notches::Hit.count.should == 1
      hit = Notches::Hit.first
      hit.url.url.should == '/posts'
      hit.user_agent.user_agent.should == 'FeedBurner/1.0'
      hit.ip.ip.should == '234.101.82.14'
      hit.session.session_id.should == 'abcd'
      Notches::UserSession.exists?(notches_session_id: hit.session.id, user_id: 7).should be_true
    end
  end
end
