require 'spec_helper'

describe TaskMailer do
  it_behaves_like 'a user notification mailer', :task, TaskMailer, 'Нова задача - %s'
end
