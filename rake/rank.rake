# coding: utf-8

namespace :rank do
  desc "Ranking list of all time"
  task :all do
    announce_locally(stat_ranking, "Ranking list of all time")
  end

  desc "Annually ranking list"
  task :annually do
    announce_locally(stat_ranking(2016), "Annually Ranking List")
  end

  desc "Monthly ranking list"
  task :monthly do
    announce_locally(stat_ranking(2016, 12), "Monthly Ranking List")
  end

  desc "Announce ranking list to issue"
  task :announce do
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
  puts "#{checkered_flag} Ranking List"
end
