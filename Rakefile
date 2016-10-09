# coding: utf-8
task default: %w[serve]

desc "Init"
task :init do
  sh "bundle install"
end

desc "Serve simply"
task :serve do
  sh "bundle exec jekyll serve --future"
end

desc "Create scaffold weekly"
task :weekly, [:date] do |t, args|
  args.with_defaults(:date => Time.now.strftime("%Y-%m-%d"))

  cur_date = args[:date]

  weekly_date  = "#{cur_date}-weekly.yml"
  weekly_html  = "#{cur_date}-weekly.md"
  weekly_email = "#{cur_date}-weekly-email.md"

  sh "touch _data/#{weekly_date}"
  sh "touch _weekly/#{weekly_html}"
  sh "touch _weekly_email/#{weekly_email}"
end