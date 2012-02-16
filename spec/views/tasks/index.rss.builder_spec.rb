# encoding: utf-8

require 'spec_helper'

describe "tasks/index.rss.builder" do
  let(:tasks) do
    1.upto(2).map do |n|
      Factory.stub(:task, name: "Task #{n}", description: "Desc #{n}")
    end
  end

  before do
    assign :tasks, tasks
    render :template => 'tasks/index.rss.builder', :layout => 'layouts/application.rss.builder'
  end

  it ("shows correct title") { rendered.should contain(rss_title("Задачи")) }

  it "lists all tasks and their contents" do
    tasks.each do |task|
      rendered.should contain(task.name)
      rendered.should contain(task.description)
    end
  end

end
