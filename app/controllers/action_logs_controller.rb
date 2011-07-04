class ActionLogsController < ApplicationController
  # GET /action_logs
  # GET /action_logs.xml
  def index
    @action_logs = ActionLog.order("created_at DESC").
                     paginate(:page => params[:page],
                              :per_page => params[:per_page].blank? ? 20 : params[:per_page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @action_logs }
    end
  end

  # GET /action_logs/1
  # GET /action_logs/1.xml
  def show
    @action_log = ActionLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @action_log }
    end
  end

  # DELETE /action_logs/1
  # DELETE /action_logs/1.xml
  def destroy
    @action_log = ActionLog.find(params[:id])
    @action_log.destroy

    respond_to do |format|
      format.html { redirect_to(action_logs_url) }
      format.xml  { head :ok }
    end
  end

  def destroy_selected
    ActionLog.destroy_all(["id IN (?)", params[:action_logs] || []])
    redirect_to action_logs_url
  end
end

