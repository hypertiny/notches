require 'spec_helper'

describe Notches::Event do
  describe "validations" do
    let(:event) do
      Notches::Event.new(
        name: Notches::Name.new(name: 'An important event'),
        scope: Notches::Scope.new(scope: 'An important person')
      )
    end

    it "valid with valid attributes" do
      expect(event).to be_valid
    end

    it "requires a name" do
      event.name = nil
      event.valid?
      expect(event.errors[:name]).to eq(["can't be blank"])
    end

    it "does not require a scope" do
      event.scope = nil
      event.valid?
      expect(event).to be_valid
    end

    it "does not validate if its Name's name is blank" do
      event.name.name = nil
      event.valid?
      expect(event.errors[:name]).to eq(["is invalid"])
    end

    it "does not validate if it has a Scope but it's invalid" do
      event.scope.scope = nil
      event.valid?
      expect(event.errors[:scope]).to eq(["is invalid"])
    end
  end

  describe ".log" do

    context "with valid attributes" do
      let(:now) { Time.zone.now }
      before do
        allow(Time).to receive_message_chain(:zone, :now).and_return(now)
      end

      it "creates a event for today and current time with those attributes" do
        Notches::Event.log(name: "An important event")
        event = Notches::Event.first
        expect(event).to be_present
        expect(event.name.name).to eq("An important event")
        expect(event.scope).to be_nil
        expect(event.date.date).to eq(now.to_date)
        expect(event.time.time.strftime('%H:%M:%S')).to eq(now.strftime('%H:%M:%S'))
      end
    end

    let(:existing_event) {
      Notches::Event.log(
        name: "An important event",
        scope: "An important person"
      )
    }

    it "does not create a new Name record if there's a record for that Name already" do
      event = Notches::Event.log(name: "An important event")
      expect(event.name.id).to eq(existing_event.name.id)
    end

    it "does not create a new Scope record if there's a record for that Scope already" do
      event = Notches::Event.log(
        name: "An important event",
        scope: "An important person"
      )
      expect(event.scope.id).to eq(existing_event.scope.id)
    end

    it "does not create a new Date record there's a record for that Date already" do
      event = Notches::Event.log(name: "Another important event")
      expect(event.date.id).to eq(existing_event.date.id)
    end

    it "does not create a new Time record if there's a record for that Time already even if date was different" do
      existing_event.time.update_attributes!(time: Time.parse('2016-08-03 14:15:59 UTC'))
      allow(Time).to receive_message_chain(:zone, :now).and_return(Time.parse('2016-08-04 14:15:59 UTC'))
      event = Notches::Event.log(name: "Another important event")
      expect(event.time.id).to eq(existing_event.time.id)
    end

    context "a event with the same name, scope, date and time exists already" do
      it "does not log the event" do
        allow(Time).to receive_message_chain(:zone, :now).and_return(existing_event.time.time)
        expect {
          event = Notches::Event.log(
            name: "An important event",
            scope: "An important person"
          )
        }.to_not change { Notches::Event.count }
      end
    end
  end
end
