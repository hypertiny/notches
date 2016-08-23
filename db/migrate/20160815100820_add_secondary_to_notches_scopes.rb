class AddSecondaryToNotchesScopes < ActiveRecord::Migration
  def up
    rename_column :notches_scopes, :scope, :primary
    add_column    :notches_scopes, :secondary, :string
    change_column_null :notches_events, :notches_scope_id, false
  end

  def down
    change_column_null :notches_events, :notches_scope_id, true
    remove_column :notches_scopes, :secondary
    rename_column :notches_scopes, :primary, :scope
  end
end
