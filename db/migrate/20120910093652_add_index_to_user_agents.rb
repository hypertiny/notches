class AddIndexToUserAgents < ActiveRecord::Migration
  def up
    add_column :notches_user_agents, :user_agent_md5, :string
    add_index :notches_user_agents, :user_agent_md5
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
    Notches::UserAgent.find_each do |user_agent|
      user_agent.update_attribute(:user_agent_md5, Digest::MD5.hexdigest(user_agent.user_agent))
    end
  end

  def down
    remove_index :notches_user_agents, :user_agent_md5
    remove_column :notches_user_agents, :user_agent_md5
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
  end
end
