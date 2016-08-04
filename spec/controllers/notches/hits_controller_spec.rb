require 'spec_helper'

describe Notches::HitsController, type: :controller do
  describe "#new" do
    it "returns an image" do
      get :new, :url => '/posts', :format => 'gif'

      expect(response.headers["Content-Type"]).to eq('image/gif')
    end

    it "logs the hit" do
      @request.env['HTTP_USER_AGENT'] = 'FeedBurner/1.0'
      allow(@request).to receive(:remote_ip).and_return('234.101.82.14')
      allow(@request).to receive(:session_options).and_return({ :id => 'abcd' })

      get :new, :url => '/posts', :user_id => 7, :format => 'gif'

      expect(Notches::Hit.count).to eq(1)
      hit = Notches::Hit.first
      expect(hit.url.url).to eq('/posts')
      expect(hit.user_agent.user_agent).to eq('FeedBurner/1.0')
      expect(hit.ip.ip).to eq('234.101.82.14')
      expect(hit.session.session_id).to eq('abcd')
      expect(Notches::UserSession.exists?(notches_session_id: hit.session.id, user_id: 7)).to eq(true)
    end
  end
end
