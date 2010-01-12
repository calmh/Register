class MailingListsController < ApplicationController
  before_filter :require_mailing_lists_permission

  def index
    @mailing_lists = MailingList.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mailing_lists }
    end
  end

  def new
    @mailing_list = MailingList.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mailing_list }
    end
  end

  def edit
    @mailing_list = MailingList.find(params[:id])
  end

  def create
    @mailing_list = MailingList.new(params[:mailing_list])

    respond_to do |format|
      if @mailing_list.save
        flash[:notice] = t:Mailing_list_created
        format.html { redirect_to(mailing_lists_path) }
        format.xml  { render :xml => @mailing_list, :status => :created, :location => @mailing_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mailing_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @mailing_list = MailingList.find(params[:id])

    respond_to do |format|
      if @mailing_list.update_attributes(params[:mailing_list])
        flash[:notice] = t:Mailing_list_updated
        format.html { redirect_to(mailing_lists_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mailing_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @mailing_list = MailingList.find(params[:id])
    @mailing_list.destroy

    respond_to do |format|
      format.html { redirect_to(mailing_lists_path) }
      format.xml  { head :ok }
    end
  end
end
