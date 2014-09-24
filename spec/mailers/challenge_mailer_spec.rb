require 'spec_helper'

describe ChallengeMailer do
  it_behaves_like 'a user notification mailer', :challenge, ChallengeMailer, 'Ново предизвикателство - %s'
end
