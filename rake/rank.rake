# coding: utf-8

namespace :rank do
  desc "Ranking list of all time"
  task :all do
    announce_locally(stat_ranking, "Ranking list of all time")
  end

  desc "Annually ranking list"
  task :annually, [:year, :github] do |t, args|
    args.with_defaults(:year => Time.now.strftime("%Y"))
    args.with_defaults(:github => false)
    year = args[:year]
    github = args[:github]
    announce_locally(stat_ranking(year), "Annually Ranking List of #{year}")

    if github == "true"
      announce_on_github(stat_ranking(year), "Annually Ranking List of #{year}")
    end
  end

  desc "Monthly ranking list"
  task :monthly, [:month, :github] do |t, args|
    args.with_defaults(:month => Time.now.strftime("%m"))
    args.with_defaults(:github => false)
    month = args[:month]
    github = args[:github]
    year = Time.now.strftime("%Y")
    announce_locally(stat_ranking(year, month), "Monthly Ranking List of #{year}-#{month}")

    if github == "true"
      announce_on_github(stat_ranking(year, month), "Ranking List of #{year}-#{month}")
    end
  end
end

def stat_ranking(year = nil, month = nil)
  ranking_list = Hash.new

  Dir.entries("_weekly").reject do |entry|
    next true if entry == "." || entry == ".."

    matching = ""
    if year != nil
      matching = "#{year}-"
      if month != nil
        matching << "#{month}-"
      end
    end

    next true if !entry.start_with? matching

    false
  end.each do |f|
    content = YAML.load(open("_weekly/#{f}").read)
    content["articles"].each do |article|
      article["referrer"] = "Unauthored" if !article.has_key?("referrer") || article["referrer"].empty?
      if ranking_list.has_key? article["referrer"]
        ranking_list[article["referrer"]] = ranking_list[article["referrer"]] + 1
      else
        ranking_list[article["referrer"]] = 1
      end
    end
  end

  ranking_list.sort_by do |name, count|
    count
  end.reverse
end

def announce_locally(ranking_list, title)
  headings = ["Name", "Count"]
  rows = []
  ranking_list.each do |name, count|
    rows << [name, count]
  end

  table = Terminal::Table.new :title => title, :headings => headings, :rows => rows
  puts table
end

def announce_on_github(ranking_list, title)
  content =<<-EOB
:checkered_flag::checkered_flag::checkered_flag:

| Name | Count |
|---|---|
  EOB

  rank = 1
  rank_emoji = ""
  ranking_list.each do |name, count|
    rank_emoji = case rank
    when 1
      ":1st_place_medal:"
    when 2
      ":2nd_place_medal:"
    when 3
      ":3rd_place_medal:"
    else
      ""
    end
    rank = rank + 1
    
    content << "| #{rank_emoji}#{name} | #{count} |\n"
  end

  client = Octokit::Client.new(:access_token => get_access_token)
  client.create_issue(get_weekly_repo, title, content)

  show_success
end
