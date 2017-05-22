# coding: utf-8

namespace :weekly do
  desc "Create weekly with scaffold"
  task :create, [:date] do |t, args|
    args.with_defaults(:date => Time.now.strftime("%Y-%m-%d"))
    weekly_date = args[:date]
    weekly_content = <<-EOF
---
articles:
  - title:    "Your Awesome Article Title"
    link:     "https://msbu-tech.github.io/"
    comment:  "The reason why you recommend this article."
    referrer: "Your Name"
    tags:    ["tag"]
---
    EOF

    create_weekly(weekly_date, weekly_content)
  end

  desc "Open weekly issue"
  task :open, [:date] do |t, args|
    args.with_defaults(:date => Time.now.strftime("%Y-%m-%d"))
    weekly_date = args[:date]

    open_issue(weekly_date)
  end

  desc "Publish weekly"
  task :publish, [:date] do |t, args|
    args.with_defaults(:date => "latest")
    weekly_date = args[:date]
    weekly_date = find_latest_weekly.split("-weekly.md").at(0) if weekly_date == "latest"
    show_info("Publishing")
    # commit
    msg = "Weekly #{weekly_date} published"
    sh "git add ."
    sh "git commit --allow-empty -m \"#{msg}\""
    sh "git push"
    # say thanks and close issue
    say_thanks_and_close_issue(weekly_date)
    # complete wunderlist
    # complete_wunderlist(weekly_date)
  end

  desc "Import weekly articles"
  task :import, [:date] do |t, args|
    args.with_defaults(:date => Time.now.strftime("%Y-%m-%d"))
    weekly_date = args[:date]
    # do import from github issues
    articles = import_articles_from_issues(get_issue_name(weekly_date))
    if articles == false
      puts "[ERROR] Import articles error!".red
      exit 1
    end
    # build frontmatter
    weekly_content = "---\narticles:\n"
    articles.each do |item|
      weekly_content << "  - title:    \"#{item[:title]}\"\n"
      weekly_content << "    link:     \"#{item[:link]}\"\n"
      weekly_content << "    referrer: \"#{item[:referrer]}\"\n"
      weekly_content << "    comment:  \"#{item[:comment]}\"\n"
      tags = Array.new
      item[:tags].split(",").each do |tag|
        tags << "\"#{tag.strip}\""
      end
      weekly_content << "    tags:    [#{tags.join(", ")}]\n"
    end
    weekly_content << "---\n"

    create_weekly(weekly_date, weekly_content)
  end

  desc "Edit the latest weekly"
  task "edit-latest" do
    latest = find_latest_weekly
    sh "$EDITOR _weekly/#{latest}"
  end

  desc "Open the latet issue"
  task "open-latest-issue" do
    link = find_issue_link
    if OS.mac?
      sh "open #{link}"
    else
      puts link
      raise StandardError, "Cannot open in non-mac system"
    end
  end
end

def get_issue_name(weekly_date)
  "#{weekly_date} 文章收集"
end

def create_weekly(weekly_date, weekly_content)
  html_file = "_weekly/#{weekly_date}-weekly.md"
  email_file = "_newsletter/#{weekly_date}-weekly.md"
  email_content = "---\ndatasrc: #{weekly_date}-weekly\n---"

  File.new(html_file, "w").syswrite(weekly_content)
  File.new(email_file, "w").syswrite(email_content)

  show_info("#{html_file} is created.")
  show_info("#{email_file} is created.")
end

def import_articles_from_issues(issue_name)
  return false if issue_name.empty?
  client = Octokit::Client.new(:access_token => get_access_token)
  # find issue
  issues = client.list_issues(get_weekly_repo, options = {:state => "open"})
  number = 0
  issues.each do |issue|
    if issue[:title].eql? issue_name
      number = issue[:number]
      break
    end
  end
  # fetch issue comment
  issue_comment = client.issue_comments(get_weekly_repo, number)
  # iterate issue comment to import articles
  articles = Array.new
  issue_comment.each do |item|
    body = item[:body]
    title = ""
    link = ""
    comment = ""
    tags = Array.new
    referrer = item[:user][:login]
    i = 0
    body.split("\r\n").each do |line|
      if line.strip.empty?
        next
      end

      case i
      when 0
        if !line.strip.eql?("/post")
          puts "[INFO] Skip comment #{number}:#{item[:id]}".green
          break
        end
      when 1
        title = Spacifier.spacify(line.strip.split("- ").at(1))
      when 2
        link = line.strip.split("- ").at(1)
      when 3
        comment = Spacifier.spacify(line.strip.split("- ").at(1))
      when 4
        tags = line.strip.split("- ").at(1)
        articles << { :title => title, :link => link, :comment => comment, :tags => tags, :referrer => referrer }
      end

      i = i + 1
    end
  end

  show_info("Import #{articles.count} article(s).")
  articles
end

def say_thanks_and_close_issue(weekly_date)
  client = Octokit::Client.new(:access_token => get_access_token)
  # find issue
  issues = client.list_issues(get_weekly_repo, options = {:state => "open"})
  number = 0
  issues.each do |issue|
    if issue[:title].eql? get_issue_name(weekly_date)
      number = issue[:number]
      break
    end
  end
  # fetch issue comment
  issue_comment = client.issue_comments(get_weekly_repo, number)
  # collect contributors
  contributors = Hash.new
  issue_comment.each do |item|
    if item[:body].strip.start_with?("/post")
      contributors[item[:user][:login]] = 1
    end
  end
  contributors_list = []
  contributors.each_key do |key|
    contributors_list << "@#{key}"
  end
  url = weekly_url(weekly_date)
  comment = <<-EOS
:fireworks:Congratulations!
:scroll:MSBU Weekly #{weekly_date} is published on <#{url}>.
:thumbsup:Thanks #{contributors_list.join ', '} for your great contributions!
  EOS
  # say thanks
  client.add_comment(get_weekly_repo, number, comment)
  show_info("Saying thanks to contributors...")
  # close issue
  client.close_issue(get_weekly_repo, number)
  show_info("Closing issue...")

  show_success
end

def open_issue(weekly_date)
  client = Octokit::Client.new(:access_token => get_access_token)
  content = <<-EOS
:loud_sound:MSBU Weekly #{weekly_date} is now in collecting.
Post your entry following the instruction of <https://github.com/msbu-tech/weekly#投稿>.
  EOS
  client.create_issue(get_weekly_repo, get_issue_name(weekly_date), content)

  show_success
end

def find_issue_link
  client = Octokit::Client.new(:access_token => get_access_token)
  # find issue
  issues = client.list_issues(get_weekly_repo, options = {:state => "open"})
  number = 0
  issues.each do |issue|
    number = issue[:number]
    break
  end
  "https://github.com/#{get_weekly_repo}/issues/#{number}"
end

def weekly_url(weekly_date)
  "https://msbu-tech.github.io/weekly/#{weekly_date}-weekly.html"
end

def complete_wunderlist(weekly_date)
  wl = Wunderlist::API.new({
    access_token: ENV["WLIST_ACCESS_TOKEN"],
    client_id: ENV["WLIST_CLIENT_ID"]
  })

  tasks = wl.tasks(["🗑Working"])
  url = weekly_url(weekly_date)
  tasks.each do |t|
    if t.title.eql?("MSBU Tech Weekly") && weekly_date.eql?(t.due_date)
      t.note.content = "MSBU Weekly #{weekly_date} is published on <#{url}>."
      t.completed = true
      t.save
      show_info("Completing wunderlist task...")
      break
    end
  end

  show_success
end
