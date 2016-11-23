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
task "test-weekly", [:date] do |t, args|
  args.with_defaults(:date => "all")
  weekly_date = args[:date]

  require "yaml"
  require "colorize"

  Dir.foreach("_weekly") do |weekly_file|
    if weekly_file == "." || weekly_file == ".."
      next
    end

    if weekly_date != "all" && weekly_file != "#{weekly_date}-weekly.md"
      next
    end

    content = YAML.load(open("_weekly/#{weekly_file}").read)

    title_record = Hash.new
    comment_record = Hash.new
    link_record = Hash.new

    content["articles"].each_with_index do |article, index|
      # check empty
      if article["title"].empty?
        puts "[ERROR] Empty title within a weekly found:"
        puts "    Filename: #{weekly_file}"
        puts "        Item: #{index}"
        puts "    >> Title: #{article['title']}".red
        exit 1
      end
      if article["link"].empty?
        puts "[ERROR] Empty link within a weekly found:"
        puts "    Filename: #{weekly_file}"
        puts "        Item: #{index}"
        puts "       Title: #{article['title']}"
        puts "     >> Link: #{article['link']}".red
        exit 1
      end
      if article.has_key?("comment") && article["comment"].empty?
        puts "[WARNING] Empty comment within a weekly found:"
        puts "    Filename: #{weekly_file}"
        puts "        Item: #{index}"
        puts "       Title: #{article['title']}"
        puts "        Link: #{article['link']}"
        puts "  >> Comment: #{article['comment']}".red
      end
      if article.has_key?("referrer") && article["referrer"].empty?
        puts "[WARNING] Empty referrer within a weekly found:"
        puts "    Filename: #{weekly_file}"
        puts "        Item: #{index}"
        puts "       Title: #{article['title']}"
        puts "        Link: #{article['link']}"
        puts "     Comment: #{article['comment']}"
        puts " >> Referrer: #{article['referrer']}".red
      end
      if article["tags"].empty?
        puts "[WARNING] Empty referrer within a weekly found:"
        puts "    Filename: #{weekly_file}"
        puts "        Item: #{index}"
        puts "       Title: #{article['title']}"
        puts "        Link: #{article['link']}"
        puts "     Comment: #{article['comment']}"
        puts "    Referrer: #{article['referrer']}"
        puts "     >> Tags: #{article['tags']}".red
      end
      # check title duplicate
      if title_record.has_key? article["title"]
        puts "[ERROR] Duplicated title within a weekly found:"
        puts "    Filename: #{weekly_file}"
        puts "        Item: #{index}"
        puts "    >> Title: #{article['title']}".red
        exit 1
      end
      title_record[article["title"]] = 1
      # check comment duplicate
      if comment_record.has_key? article["comment"]
        puts "[ERROR] Duplicated comment within a weekly found:"
        puts "    Filename: #{weekly_file}"
        puts "        Item: #{index}"
        puts "       Title: #{article['title']}"
        puts "  >> Comment: #{article['comment']}".red
        exit 1
      end
      comment_record[article["comment"]] = 1
      # check link duplicate
      if link_record.has_key? article["link"]
        puts "[ERROR] Duplicated link within a weekly found:"
        puts "    Filename: #{weekly_file}"
        puts "        Item: #{index}"
        puts "       Title: #{article['title']}"
        puts "     >> Link: #{article['link']}".red
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
          puts "       Title: #{article['title']}"
          puts "     >> Tags: #{article['tags']}".red
          exit 1
        end
        if tag.empty?
          puts "[WARNING] Duplicated tags found:"
          puts "    Filename: #{weekly_file}"
          puts "        Item: #{index}"
          puts "       Title: #{article['title']}"
          puts "     >> Tags: #{article['tags']}".red
        else
          tags_record[tag] = 1
        end
      end
    end
  end

  puts "Success."
end

desc "Find the latest weekly and edit with your editor"
task "edit-latest" do
  latest = Dir.entries("_weekly").sort_by {|x| File.mtime("_weekly/#{x}")}.reject {|entry| entry == "." || entry == ".."}.last
  sh "$EDITOR _weekly/#{latest}"
end
