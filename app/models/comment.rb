class Comment < ActiveRecord::Base
  belongs_to :bug
end
