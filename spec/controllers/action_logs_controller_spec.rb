require "spec_helper"

describe ActionLogsController, "index" do
  before(:each) do
    @params = { :per_page => "123", :page => "456" }
    @paginated_action_logs = mock("ActionLogs")
    @action_logs = mock("ActionLogs", :paginate => @paginated_action_logs)
    ActionLog.stub(:order) { @action_logs }
  end

  it "should order the action logs" do
    ActionLog.should_receive(:order).with("created_at DESC").and_return(@action_logs)
    get :index, @params
  end

  it "should paginate the ordered action logs" do
    @action_logs.should_receive(:paginate).with(:page => "456", :per_page => "123").
      and_return(@paginated_action_logs)
    get :index, @params
  end

  it "should respond OK" do
    get :index, @params
    response.should be_success    
  end
end

describe ActionLogsController, "show" do
  before(:each) do
    @params = { :id => "123" }
    @action_log = mock_model(ActionLog)
    ActionLog.stub(:find) { @action_log }
  end

  it "should find the action_log" do
    ActionLog.should_receive(:find).with("123").and_return(@action_log)
    get :show, @params
  end

  it "should respond OK" do
    get :show, @params
    response.should be_success    
  end
end

describe ActionLogsController, "destroy" do
  before(:each) do
    @params = { :id => "123" }
    @action_log = mock_model(ActionLog, :destroy => nil)
    ActionLog.stub(:find) { @action_log }
  end

  it "should find the action_log" do
    ActionLog.should_receive(:find).with("123").and_return(@action_log)
    delete :destroy, @params
  end

  it "should destroy the action logs" do
    @action_log.should_receive(:destroy)
    delete :destroy, @params
  end

  it "should redirect to action_logs_url" do
    delete :destroy, @params
    response.should redirect_to(action_logs_url)    
  end
end

describe ActionLogsController, "destroy" do
  before(:each) do
    @params = { :action_logs => ["123", "456"] }
    ActionLog.stub(:destroy_all)
  end

  it "should find the action_log" do
    ActionLog.should_receive(:destroy_all).with(["id IN (?)", ["123", "456"]])
    delete :destroy_selected, @params
  end

  it "should redirect to action_logs_url" do
    delete :destroy_selected, @params
    response.should redirect_to(action_logs_url)    
  end
end

