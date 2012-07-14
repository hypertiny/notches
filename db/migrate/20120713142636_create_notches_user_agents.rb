class CreateNotchesUserAgents < ActiveRecord::Migration
  def up
    create_table :notches_user_agents do |t|
      t.text :user_agent
    end
    add_column :notches_hits, :notches_user_agent_id, :integer
    change_table :notches_hits do |t|
      t.remove_index :name => :notches_index
    end
    add_index :notches_hits, [
      :notches_time_id,
      :notches_date_id,
      :notches_ip_id,
      :notches_session_id,
      :notches_url_id,
      :notches_user_agent_id
    ], :name => :notches_index, :unique => true
  end

  def down
    change_table :notches_hits do |t|
      t.remove_index :name => :notches_index
    end
    add_index :notches_hits, [
      :notches_time_id,
      :notches_date_id,
      :notches_ip_id,
      :notches_session_id,
      :notches_url_id
    ], :name => :notches_index, :unique => true
    remove_column :notches_hits, :notches_user_agent_id
    drop_table :notches_user_agents
  end
end
