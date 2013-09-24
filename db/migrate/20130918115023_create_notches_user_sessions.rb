class CreateNotchesUserSessions < ActiveRecord::Migration
  def up
    create_table :notches_user_sessions do |t|
      t.integer :user_id, :null => false
      t.integer :notches_session_id, :null => false
    end
    add_index :notches_user_sessions, :user_id, :unique => true
  end

  def down
    remove_index :notches_user_sessions, :user_id
    drop_table :notches_user_sessions
  end
end
