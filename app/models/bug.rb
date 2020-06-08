class Bug < ActiveRecord::Base
  has_many :comments
  has_many :bookmarks
  def current_user_studied_at user_id
    return Comment.where("user_id = ? and bug_id = ?", user_id, self.id).try(:first)
  end
end
