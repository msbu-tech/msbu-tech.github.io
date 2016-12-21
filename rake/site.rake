# coding: utf-8

task default: %w[serve]

desc "Serve simply"
task :serve do
  sh "bundle exec jekyll serve --future"
end