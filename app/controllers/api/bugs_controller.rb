module API
  class BugsController < ActionController::Base
    def index
      params[:order_by] ||= 'bugs.id desc'
      @bugs = Bug.includes(:comments).joins(:comments)
      @bugs = @bugs.where('wybug_title like ?', "%#{params[:title]}%") if params[:title].present?
      @bugs = @bugs.where('wybug_rank_0 > ?', params[:bug_rank_greater_than]) if params[:bug_rank_greater_than].present?
      @bugs = @bugs.where('wybug_rank_0 = ?', params[:bug_rank]) if params[:bug_rank].present? && params[:bug_rank_greater_than].blank?

      # 查看学习过的
      if params[:user_id].present? && params[:is_studied].present?
        if params[:is_studied] == '1'
          @bugs = @bugs.where("comments.id is not null")
          #@bugs = @bugs.order('comments.id desc')
        else
          @bugs = @bugs.where("comments.id is null")
          #@bugs = @bugs.order(params[:order_by])
        end
      end
      @bugs = @bugs.order(params[:order_by])
      @bugs = @bugs.page(params[:page]).per(100)
      @bugs_count = @bugs.count
      render json: {
        result: @bugs.map{|bug|
          {
            id: bug.id,
            title: bug.wybug_title,
            date: bug.wybug_date,
            type: bug.wybug_type,
            rank: bug.wybug_rank_0
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
      result = @bug.to_json
      render json: @bug.to_json
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
