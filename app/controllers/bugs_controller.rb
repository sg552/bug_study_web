class BugsController < ApplicationController
  def index
    params[:order_by] ||= 'id desc'
    @bugs = Bug.includes(:comments)
    @bugs = @bugs.where('wybug_title like ?', "%#{params[:title]}%") if params[:title].present?
    @bugs = @bugs.where('wybug_rank_0 > ?', params[:bug_rank_greater_than]) if params[:bug_rank_greater_than].present?
    @bugs = @bugs.where('wybug_rank_0 = ?', params[:bug_rank]) if params[:bug_rank].present? && params[:bug_rank_greater_than].blank?
    @bugs_count = @bugs.count
    @bugs = @bugs.order(params[:order_by])
    @bugs = @bugs.page(params[:page]).per(100)
  end

  def show
    @bug = Bug.find params[:id]
    @comment = @bug.comments.where("user_id = ?", current_user.id).first
    if @comment.blank?
      @comment = Comment.new bug_id: params[:id], user_id: current_user.id
    end
  end
end
