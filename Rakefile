# coding: utf-8
task default: %w[serve]

desc "Init"
task :init do
  sh "bundle install"
end

desc "Serve simply"
task :serve do
  sh "bundle exec jekyll serve"
end

desc "Serve with draft"
task :draft do
  sh "bundle exec jekyll serve --draft"
end

