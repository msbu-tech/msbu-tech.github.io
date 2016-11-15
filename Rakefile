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

  weekly_html_file  = "_weekly/#{cur_date}-weekly.md"
  weekly_email_file = "_newsletter/#{cur_date}-weekly-email.md"

  weekly_frontmatter   = "---\ndatasrc: #{cur_date}-weekly\n---"
  weekly_frontmatter_scaffold = <<-EOF
---
articles:
  - title:    "Your Awesome Article Title"
    link:     "https://msbu-tech.github.io/"
    comment:  "The reason why you recommend this article."
    referrer: "Your Name"
    tags:    ["tag"]
---
  EOF

  File.new(weekly_html_file, "w").syswrite(weekly_frontmatter_scaffold)
  File.new(weekly_email_file, "w").syswrite(weekly_frontmatter)
end

desc "Test weekly duplicate"
task :test_weekly do
  require "yaml"

  Dir.foreach("_weekly") do |weekly_file|
    if weekly_file == "." || weekly_file == ".."
      next
    end

    content = YAML.load(open("_weekly/#{weekly_file}").read)

    title_record = Hash.new
    comment_record = Hash.new
    link_record = Hash.new

    content["articles"].each_with_index do |article, index|
      # check title duplicate
      if title_record.has_key? article["title"]
        puts "[ERROR] Duplicated name within a weekly found:"
        puts "    Filename: #{weekly_file}"
        puts "        Item: #{index}"
        puts " >> Name:     #{article['title']}"
        exit 1
      end
      title_record[article["title"]] = 1
      # check comment duplicate
      if comment_record.has_key? article["comment"]
        puts "[ERROR] Duplicated comment within a weekly found:"
        puts "    Filename: #{weekly_file}"
        puts "        Item: #{index}"
        puts "    Name:     #{article['title']}"
        puts "    Comment:  #{article['comment']}"
        exit 1
      end
      comment_record[article["comment"]] = 1
      # check link duplicate
      if link_record.has_key? article["link"]
        puts "[ERROR] Duplicated link within a weekly found:"
        puts "    Filename: #{weekly_file}"
        puts "        Item: #{index}"
        puts "    Name:     #{article['title']}"
        puts " >> Link:     #{article['link']}"
        exit 1
      end
      link_record[article["link"]] = 1
      # check tags duplicate
      tags_record = Hash.new
      article["tags"].each do |tag|
        if tags_record.has_key? tag
          puts "[ERROR] Duplicated tags found:"
          puts "    Filename: #{weekly_file}"
          puts "        Item: #{index}"
          puts "    Name:     #{article['title']}"
          puts " >> Tags:     #{article['tags']}"
          exit 1
        end
        tags_record[tag] = 1
      end
    end
  end

  puts "Success."
end
