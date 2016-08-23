require 'spec_helper'

describe Notches::Event do
  describe "validations" do
    let(:event) do
      Notches::Event.new(
        name: Notches::Name.new(name: 'An event'),
        scope: Notches::Scope.new(primary: 'A person', secondary: '')
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

    it "requires a scope" do
      event.scope = nil
      event.valid?
      expect(event.errors[:scope]).to eq(["can't be blank"])
    end

    it "does not validate if its Name's name is blank" do
      event.name.name = nil
      event.valid?
      expect(event.errors[:name]).to eq(["is invalid"])
    end

    it "does not validate if it has a scope but it's value is nil" do
      event.scope.primary = nil
      event.valid?
      expect(event.errors[:scope]).to eq(["is invalid"])
    end

    it "does not validate if it has a secondary scope but no primary scope" do
      event.scope.primary = nil
      event.scope.secondary = 'Secondary scope'
      event.valid?
      expect(event.errors[:scope]).to eq(["is invalid"])
    end
  end

  describe ".log" do
    let(:now) { Time.zone.now }
    let(:existing_event) { Notches::Event.log(name: "An event", scope: "A person") }

    before do
      allow(Time).to receive_message_chain(:zone, :now).and_return(now)
    end

    context "with valid attributes" do
      it "creates a event for today and current time with those attributes" do
        Notches::Event.log(name: "An event")
        event = Notches::Event.first
        expect(event).to be_present
        expect(event.name.name).to eq("An event")
        expect(event.scope.primary).to eq("")
        expect(event.scope.secondary).to eq("")
        expect(event.date.date).to eq(now.to_date)
        expect(event.time.time.strftime('%H:%M:%S')).to eq(now.strftime('%H:%M:%S'))
      end
    end

    it "does not create a new Name record if there's a record for that Name already" do
      event = Notches::Event.log(name: "An event")
      expect(event.name.id).to eq(existing_event.name.id)
    end

    it "does not create a new Scope record if there's a record for that Scope already" do
      event = Notches::Event.log(name: "An event", scope: "A person")
      expect(event.scope.id).to eq(existing_event.scope.id)
    end

    it "does not create a new Date record there's a record for that Date already" do
      event = Notches::Event.log(name: "Another event")
      expect(event.date.id).to eq(existing_event.date.id)
    end

    it "does not create a new Time record if there's a record for that Time already even if date was different" do
      event = Notches::Event.log(name: "Another event")
      expect(event.time.id).to eq(existing_event.time.id)
    end

    context "a event with the same name, scope, date and time exists already" do
      it "does not log the event" do
        event_attributes = {
          name: "An event",
          scope: "A person"
        }
        Notches::Event.log(event_attributes)

        expect {
          Notches::Event.log(event_attributes)
        }.to_not change { Notches::Event.count }
      end
    end

    context "logging an event with a primary and secondary scope" do
      it do
        event = Notches::Event.log(
          name: "An event",
          scope: ["A person", "An object"]
        )

        expect(event).to be_persisted
        expect(event.name.name).to eq("An event")
        expect(event.scope.primary).to eq("A person")
        expect(event.scope.secondary).to eq("An object")
        expect(event.date.date).to eq(now.to_date)
        expect(event.time.time.strftime('%H:%M:%S')).to eq(now.strftime('%H:%M:%S'))
      end
    end

    context "logging an event with a primary and secondary scope when a event with same name, scope, date and time exists already" do
      it "does not log the event" do
        event_attributes = {
          name: "An event",
          scope: ["A person", "An object"]
        }
        Notches::Event.log(event_attributes)

        expect {
          Notches::Event.log(event_attributes)
        }.to_not change { Notches::Event.count }
      end
    end
  end
end
