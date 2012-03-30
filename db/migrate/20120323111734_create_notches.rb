class CreateNotches < ActiveRecord::Migration
  def up
    create_table :notches_urls do |t|
      t.string :url
    end
    create_table :notches_sessions do |t|
      t.string :session_id
    end
    create_table :notches_ips do |t|
      t.string :ip
    end
    create_table :notches_dates do |t|
      t.date :date
    end
    create_table :notches_times do |t|
      t.time :time
    end
    create_table :notches_hits do |t|
      t.integer :notches_url_id, :null => false
      t.integer :notches_session_id, :null => false
      t.integer :notches_ip_id, :null => false
      t.integer :notches_date_id, :null => false
      t.integer :notches_time_id, :null => false
    end
    add_index :notches_urls, :url
    add_index :notches_sessions, :session_id
    add_index :notches_ips, :ip
    add_index :notches_dates, :date
    add_index :notches_times, :time
    add_index :notches_hits, [
      :notches_time_id,
      :notches_date_id,
      :notches_ip_id,
      :notches_session_id,
      :notches_url_id
    ], :name => :notches_index, :unique => true
  end

  def down
    remove_index :notches_urls, :url
    remove_index :notches_sessions, :session_id
    remove_index :notches_ips, :ip
    remove_index :notches_dates, :date
    remove_index :notches_times, :time
    change_table :notches_hits do |t|
      t.remove_index :name => :notches_index
    end
    drop_table :notches_urls
    drop_table :notches_sessions
    drop_table :notches_ips
    drop_table :notches_dates
    drop_table :notches_times
    drop_table :notches_hits
  end
end
