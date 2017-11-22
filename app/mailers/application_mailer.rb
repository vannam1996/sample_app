class ApplicationMailer < ActionMailer::Base
  default from: Settings.active.default_from
  layout "mailer"
end
