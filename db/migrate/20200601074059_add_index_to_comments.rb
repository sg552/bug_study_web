class AddIndexToComments < ActiveRecord::Migration
  def change
    add_index :comments, :bug_id
    add_index :comments, :user_id
  end
end
