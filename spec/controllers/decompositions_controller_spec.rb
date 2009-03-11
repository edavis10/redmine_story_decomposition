require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DecompositionsController, "#create with no new issue" do
  integrate_views

  before(:each) do
    controller.stub!(:find_issue)
    controller.stub!(:find_project)
    controller.stub!(:authorize)
    get :create
  end

  it 'should render nothing' do
    response.should be_success
    response.body.should be_blank
  end
end

describe DecompositionsController, "#new" do
  integrate_views

  before(:each) do
    @tracker = mock_model(Tracker, :id => 1)
    @project = mock_model(Project, :trackers => [@tracker], :all_issue_custom_fields => [])
    @issue = mock_model(Issue, :id => 1000, :project => @project)
    controller.stub!(:current_issue).and_return(@issue)

    # Filters
    controller.stub!(:find_issue)
    controller.stub!(:find_project)
    controller.stub!(:authorize)
  end

  def send_post(extra_params = {})
    post(:new, {
           :new_subissue => {
             :subject => "Test issue",
             :tracker_id => @tracker.id,
             :assigned_to_id => nil
           }
         }.merge(extra_params))

  end

  it 'should be successful' do
    send_post
    response.should be_success
  end

  it 'should render the new RJS' do
    send_post
    response.should render_template('decompositions/new.js.rjs')
  end

  it 'should setup the child issue for the view' do
    send_post
    assigns[:child_issue].should_not be_nil
  end

  it 'should insert a row to the table body' do
    send_post
    response.should have_rjs(:insert, :top, 'subtasks_body')
  end
end

describe DecompositionsController, "#create" do
  integrate_views

  before(:each) do
    @tracker = mock_model(Tracker, :id => 1)
    @project = mock_model(Project, :trackers => [@tracker], :all_issue_custom_fields => [])
    @issue = mock_model(Issue, :id => 1000, :project => @project)
    controller.stub!(:current_issue).and_return(@issue)

    @mocked_child_issue = Issue.new
    controller.stub!(:build_child_issue).and_return(@mocked_child_issue)
    # Filters
    controller.stub!(:find_issue)
    controller.stub!(:find_project)
    controller.stub!(:authorize)
  end

  def send_post(extra_params = {})
    post(:create, {
           :new_subissue => {
             :subject => "Test issue",
             :tracker_id => @tracker.id,
             :assigned_to_id => nil
           }
         }.merge(extra_params))

  end

  describe 'with no errors saving' do
    before(:each) do
      @mocked_child_issue.stub!(:save_as_subissue_of).and_return(true)
    end

    it 'should be successful' do
      send_post
      response.should be_success
    end
    
    it 'should render the create RJS' do
      send_post
      response.should render_template('decompositions/create.js.rjs')
    end

    it 'should setup the child issue for the view' do
      send_post
      assigns[:child_issue].should_not be_nil
    end

    it 'should save the child issue as a subissue of the parent' do
      controller.should_receive(:build_child_issue).and_return(@mocked_child_issue)
      send_post
    end
  end  

  describe 'with errors saving' do
    before(:each) do
      @mocked_child_issue.stub!(:save_as_subissue_of).and_return(false)
    end

    it 'should not be successful' do
      send_post
      response.should_not be_success
    end
    
    it 'should render the create error RJS' do
      send_post
      response.should render_template('decompositions/create_error.js.rjs')
    end
  end
end
