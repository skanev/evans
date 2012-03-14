# variables to be used from default layout
@title = 'Активност'

# a little adjustment to feed object, in order to keep the RSS items logic
def @feed.each
  each_activity do |activity|
    yield activity
  end
end

@items = @feed

# methods to be used from default layout
def feed_path(activity)
  activities_path
end

def feed_title(activity)
  "#{activity.user_name} #{activity.describe} решение на #{activity.subject}"
end

def feed_body(activity)
  render 'activity_content', :activity => activity
end

def feed_date(activity)
  activity.happened_at
end
