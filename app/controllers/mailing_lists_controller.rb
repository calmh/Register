class MailingListsController < ApplicationController
  before_filter :require_mailing_lists_permission

  def index
    @mailing_lists = MailingList.find(:all, :order => "email")
  end

  def new
    @mailing_list = MailingList.new
  end

  def edit
    @mailing_list = MailingList.find(params[:id])
  end

  def create
    @mailing_list = MailingList.new(params[:mailing_list])

    if @mailing_list.save
      flash[:notice] = t:Mailing_list_created
      redirect_to(mailing_lists_path)
    else
      render :action => "new"
    end
  end

  def update
    @mailing_list = MailingList.find(params[:id])

    if @mailing_list.update_attributes(params[:mailing_list])
      flash[:notice] = t:Mailing_list_updated
      redirect_to(mailing_lists_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @mailing_list = MailingList.find(params[:id])
    @mailing_list.destroy

    redirect_to(mailing_lists_path)
  end
end
