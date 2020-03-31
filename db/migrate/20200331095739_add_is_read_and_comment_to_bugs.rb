class AddIsReadAndCommentToBugs < ActiveRecord::Migration
  def change
    add_column :bugs, :is_viewed, :boolean, default: false
    add_column :bugs, :viewed_at, :datetime
    add_column :bugs, :comment, :text
  end
end
