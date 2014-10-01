class MembersController < ApplicationController
  def index
    @members = Member.all.order(:order)
  end

  def edit
    @member = Member.find(params[:id])
  end

  def new
    @member = Member.new
    # 新規メンバのデフォルト order は，現在の最大値に10を加えて1の位を切り捨てた数
    # e.g. 現在の最大値が13の場合は20がデフォルト
    @member.order = (Member.maximum(:order) + 10) / 10 * 10
  end

  def create
    @member = Member.create(member_params)
    redirect_to members_path
  end

  def update
    Member.find(params[:id]).update(member_params)
    redirect_to members_path
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    redirect_to members_path
  end

  private
  def member_params
    params.require(:member).permit(:name, :order)
  end
end
