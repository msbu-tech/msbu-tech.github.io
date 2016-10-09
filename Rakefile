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

  weekly_data_file  = "_data/#{cur_date}-weekly.yml"
  weekly_html_file  = "_weekly/#{cur_date}-weekly.md"
  weekly_email_file = "_weekly_email/#{cur_date}-weekly-email.md"

  weekly_frontmatter   = "---\ndatasrc: #{cur_date}-weekly\n---"
  weekly_yaml_scaffold = <<-EOF
articles:
  - title:    "Your Awesome Article Title"
    link:     "https://msbu-tech.github.io/"
    comment:  "The reason why you recommend this article."
    referrer: "Your Name"
    tags:    ["tag"]
  EOF

  File.new(weekly_html_file, "w").syswrite(weekly_frontmatter)
  File.new(weekly_email_file, "w").syswrite(weekly_frontmatter)
  File.new(weekly_data_file, "w").syswrite(weekly_yaml_scaffold)
end