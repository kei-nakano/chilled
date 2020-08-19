class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@chilled.site'
  layout 'mailer'
end
