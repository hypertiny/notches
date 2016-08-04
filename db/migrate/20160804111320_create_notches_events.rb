class CreateNotchesEvents < ActiveRecord::Migration
  def up
    create_table :notches_names do |t|
      t.string :name
    end
    create_table :notches_scopes do |t|
      t.string :scope
    end
    create_table :notches_events do |t|
      t.integer :notches_name_id, :null => false
      t.integer :notches_scope_id
      t.integer :notches_date_id, :null => false
      t.integer :notches_time_id, :null => false
    end
    add_index :notches_names, :name
    add_index :notches_scopes, :scope
    add_index :notches_events, [
      :notches_time_id,
      :notches_date_id,
      :notches_name_id,
      :notches_scope_id
    ], :name => :notches_event_index, :unique => true
  end

  def down
    remove_index :notches_scopes, :scope
    remove_index :notches_names, :name
    change_table :notches_events do |t|
      t.remove_index :name => :notches_event_index
    end
    drop_table :notches_scopes
    drop_table :notches_names
    drop_table :notches_events
  end
end
