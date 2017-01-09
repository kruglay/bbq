class ApplicationMailer < ActionMailer::Base
  default from: "sembbq@heroku.com"
  layout 'mailer'
end
