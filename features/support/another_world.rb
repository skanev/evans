# Step helpers, confusingly named after something awesome
module AnotherWorld
  def last_sent_email
    ActionMailer::Base.deliveries.last.try(:body).try(:to_s) or
      raise "Expected to have sent an email"
  end

  def backdoor_login(user)
    visit "/backdoor/login?email=#{CGI.escape(user.email)}"
    @current_user = user
  end

  def backdoor_logout
    visit '/backdoor/logout'
    @current_user = nil
  end

  def log_in_as_admin
    backdoor_login create(:admin)
  end

  def log_in_as_student
    backdoor_login create(:user)
  end

  def log_in_as_another_user
    log_in_as_student
  end

  def current_user
    @current_user
  end

  def file_fixture(file_name)
    Rails.root.join('spec/fixtures/files', file_name)
  end

  def fill_in_fields(table)
    rows = table.respond_to?(:rows_hash) ? table.rows_hash : table

    rows.each do |key, value|
      fill_in key, with: value
    end
  end

  def current_path
    URI.parse(current_url).path
  end

  def visit_link_in_last_email
    link = last_sent_email[%r{http://trane.example.org(/[^ \n"']+)}, 1]
    fail "Expected last sent email to contain a link" if link.blank?
    visit link
  end
end

World(AnotherWorld)
