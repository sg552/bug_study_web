class RemoveIsReadAndCommentFromBugs < ActiveRecord::Migration
  def change
    remove_column :bugs, :is_viewed
    remove_column :bugs, :viewed_at
    remove_column :bugs, :comment
  end
end
