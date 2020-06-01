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
        if params[:is_studied] == '1'
          @bugs = @bugs.where("comments.user_id = ? and comments.id is not null", params[:user_id])
          @bugs = @bugs.order('comments.id desc')
        else
          @bugs = @bugs.where("comments.id is null", params[:user_id])
          @bugs = @bugs.order(params[:order_by])
        end
      end
      @bugs = @bugs.page(params[:page]).per(100)
      @bugs_count = @bugs.count
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
        replys: @bug.replys
      }

      comments = Comment.where("bug_id = ? and user_id = ?", params[:id], params[:user_id])
      if comments.present?
        comment = comments.first
        result = result.merge comment: comment.comment, comment_updated_at: comment.updated_at
      end
      render json: result
    end

    def update_comment
      @bug = Bug.find params[:id]
      if @bug.comment.present?
        @comment = @bug.comment
      else
        @comment = Comment.new bug_id: params[:id], user_id: params[:user_id]
      end
      @comment.comment = params[:comment]
      @comment.save!
      render json: { result: 'success'}
    end
  end
end
