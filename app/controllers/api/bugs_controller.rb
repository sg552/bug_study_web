module API
  class BugsController < ActionController::Base
    def index
      params[:order_by] ||= 'bugs.id desc'
      #@bugs = Bug.includes(:comments).joins(:comments)
      @bugs = Bug.joins("left outer join comments on comments.bug_id = bugs.id")
      #@bugs = @bugs.where('wybug_title like ?', "%#{params[:title]}%") if params[:title].present?
      #@bugs = @bugs.where('wybug_rank_0 > ?', params[:bug_rank_greater_than]) if params[:bug_rank_greater_than].present?
      #@bugs = @bugs.where('wybug_rank_0 = ?', params[:bug_rank]) if params[:bug_rank].present? && params[:bug_rank_greater_than].blank?

      # 查看学习过的
      if params[:user_id].present? && params[:is_studied].present?

        # studied_bugs
        @bugs = @bugs.where("comments.user_id = ? and comments.id is not null", params[:user_id])
          .group('bugs.id')
        if params[:is_studied] == '1'
          @bugs = @bugs.order('comments.id desc')
        else
          @not_studied_bugs = Bug.where.not(id: @bugs.map(&:id))
          @bugs = @not_studied_bugs
          @bugs = @bugs.order(params[:order_by])
        end
      end
      @bugs = @bugs.page(params[:page]).per(100)
      render json: {
        result: @bugs.map{|bug|
          {
            id: bug.id,
            title: bug.wybug_title,
            date: bug.wybug_date,
            type: bug.wybug_type,
            rank: bug.wybug_rank_0,
            commented_at: (bug.comments.first.created_at rescue '')
          }
        }
      }
    end

    def bookmarks
      @bugs = Bug.joins(:bookmarks).where('bookmarks.user_id = ?', params[:user_id])
        .order("bookmarks.id desc")
        .limit(1000)
      render json: {
        result: @bugs.map{|bug|
          {
            id: bug.id,
            title: bug.wybug_title,
            date: bug.wybug_date,
            type: bug.wybug_type,
            rank: bug.wybug_rank_0,
            commented_at: ''
          }
        }
      }
    end


    def show
      @bug = Bug.find params[:id]
      @bug.wybug_detail = @bug.wybug_detail.gsub('width="600"', 'width="100%"')
        .gsub("<pre><code>", "<p>")
        .gsub("</code></pre>", "</p>")
        .gsub('<fieldset class="fieldset fieldset-code">', "")
        .gsub("</fieldset>", "")
      if @bug.wybug_detail.match(/^>\t/)
        @bug.wybug_detail = @bug.wybug_detail.sub(">\t", '')
      end

      comments = Comment.where('bug_id = ? and user_id = ?', params[:id], params[:user_id])
      result = {
        id: params[:id],
        wybug_id: @bug.wybug_id,
        wybug_author: @bug.wybug_author,
        wybug_rank_0: @bug.wybug_rank_0,
        wybug_level: @bug.wybug_level,
        wybug_title: @bug.wybug_title,
        wybug_type: @bug.wybug_type,
        wybug_detail: @bug.wybug_detail,
        wybug_reply: @bug.wybug_reply,
        replys: @bug.replys,
        comment:(comments.first.comment rescue '')
      }

      render json: result
    end

    def update_comment
      @bug = Bug.find params[:id]
      comments = Comment.where('bug_id = ? and user_id = ?', params[:id], params[:user_id])
      if comments.present?
        @comment = comments.first
      else
        @comment = Comment.new bug_id: params[:id], user_id: params[:user_id]
      end
      @comment.comment = params[:comment]
      @comment.save!

      next_bug_id = Bug.where('id < ?', params[:id]).order('id desc').first.id

      render json: {
        result: 'success',
        next_bug_id: next_bug_id
      }
    end

    def update_bookmark
      @bug = Bug.find params[:id]
      bookmarks = Bookmark.where('bug_id = ? and user_id = ?', params[:id], params[:user_id])

      if bookmarks.present?
        @bookmark = bookmarks.first
      else
        @bookmark = Bookmark.new bug_id: params[:id], user_id: params[:user_id]
      end
      @bookmark.save!

      render json: {
        result: 'success'
      }
    end
  end
end
