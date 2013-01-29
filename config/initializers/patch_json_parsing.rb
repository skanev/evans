# Patch JSON parsing to avoid issues described in CVE-2013-0333.
# https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-security/1h2DR63ViGo
ActiveSupport::JSON.backend = 'JSONGem'
