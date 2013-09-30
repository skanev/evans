if ENV['COVERAGE'] or ENV['TRAVIS']
  SimpleCov.start 'rails' do
    add_filter 'lib/language'         # We can't always test those
    add_filter 'lib/queue_monitoring' # This is a hack, digging in SideKiq's internal
  end
end
