# Related to CVE-2013-0156. Find more info here:
# https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-security/61bkgvnSGTQ
ActionDispatch::ParamsParser::DEFAULT_PARSERS.delete(Mime::XML)
