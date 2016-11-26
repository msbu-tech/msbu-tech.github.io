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
task :weekly, [:date, :import_flag] do |t, args|
  args.with_defaults(:date => Time.now.strftime("%Y-%m-%d"))
  args.with_defaults(:import_flag => true)

  weekly_date = args[:date]
  import_flag = args[:import_flag] == "true" || args[:import_flag] == true ? true : false

  weekly_html_file  = "_weekly/#{weekly_date}-weekly.md"
  weekly_email_file = "_newsletter/#{weekly_date}-weekly-email.md"

  weekly_frontmatter   = "---\ndatasrc: #{weekly_date}-weekly\n---"
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

  weekly_content = weekly_frontmatter_scaffold

  # do import from github issues
  if import_flag == true
    articles = import_articles_from_issues("#{weekly_date} 文章收集")
    if articles == false
      puts "Error: import articles error!"
      exit 1
    end
    weekly_content = "---\narticles:\n"
    articles.each do |item|
      weekly_content << "  - title:    \"#{item[:title]}\"\n"
      weekly_content << "    link:     \"#{item[:link]}\"\n"
      weekly_content << "    referrer: \"#{item[:referrer]}\"\n"
      weekly_content << "    comment:  \"#{item[:comment]}\"\n"
      tags = Array.new
      # item[:tags] = [] << item[:tags] if !item[:tags].include?(",")
      item[:tags].split(",").each do |tag|
        tags << "\"#{tag.strip}\""
      end
      weekly_content << "    tags:    [#{tags.join(", ")}]\n"
    end
    weekly_content << "---\n"
  end

  File.new(weekly_html_file, "w").syswrite(weekly_content)
  File.new(weekly_email_file, "w").syswrite(weekly_frontmatter)
end

desc "Test weekly duplicate"
task "test-weekly", [:date] do |t, args|
  args.with_defaults(:date => "all")
  weekly_date = args[:date]
  weekly_date = find_latest_weekly.split("-weekly.md").at(0) if weekly_date == "latest"
  
  require "yaml"
  require "colorize"

  Dir.foreach("_weekly") do |weekly_file|
    if weekly_file == "." || weekly_file == ".."
      next
    end

    if weekly_date != "all" && weekly_file != "#{weekly_date}-weekly.md"
      next
    end

    puts "Checking #{weekly_file}...".green

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
  latest = find_latest_weekly
  sh "$EDITOR _weekly/#{latest}"
end


def find_latest_weekly
  require "date"

  Dir.entries("_weekly").reject do |entry|
    entry == "." || entry == ".."
  end.sort_by do |x|
    Date.strptime(x.split("-weekly.md").at(0), "%Y-%m-%d").to_time.to_i
  end.last
end

def import_articles_from_issues(issue_name)
  return false if issue_name.empty?

  require "octokit"

  repo_name = "msbu-tech/weekly".freeze
  access_token = ENV["ACCESS_TOKEN"]

  return false if access_token == nil || access_token.empty?

  client = Octokit::Client.new(:access_token => access_token)

  # find issue
  issues = client.list_issues(repo_name, options = {:state => "open", :labels => "收集中"})
  number = 0
  issues.each do |issue|
    if issue[:title].eql? issue_name
      number = issue[:number]
      break
    end
  end
  # fetch issue comment
  issue_comment = client.issue_comments(repo_name, number)
  # iterate issue comment to import articles
  articles = Array.new
  issue_comment.each do |item|
    body = item[:body]
    title = ""
    link = ""
    comment = ""
    tags = Array.new
    referrer = item[:user][:login]
    body.split("\r\n").each_with_index do |line, i|
      case i
      when 0
        title = line.strip.split("- ").at(1)
      when 1
        link = line.strip.split("- ").at(1)
      when 2
        comment = line.strip.split("- ").at(1)
      when 3
        tags = line.strip.split("- ").at(1)
      end
    end
    articles << { :title => title, :link => link, :comment => comment, :tags => tags, :referrer => referrer }
  end

  articles
end