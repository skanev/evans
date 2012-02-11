require 'spec_helper'

describe "tasks/index.html.haml" do

  describe "show RSS feed" do
    let(:tasks) { Task.all }

    before do
      view.stub :admin_only => false
     assign :tasks, tasks
    end

    it_behaves_like "has RSS feed" do
      let(:rss_url) { tasks_url(:rss) }
    end
  end

end