#!/usr/bin/env ruby

# Stolen from Nathan: <https://github.com/aniero/dotfiles/blob/master/install.rb>
# which was originally taken from <http://errtheblog.com/posts/89-huba-huba>

home = File.expand_path(ENV['HOME'])

opts = {}
ARGV.each do |arg|
  if arg =~ /^--(.*)$/
    opts[$1.gsub("-", "_").to_sym] = true
  end
end

Dir['*'].each do |file|
  next if file =~ /^\.|install|tags|README/
  target = File.join(home, ".#{file}")
  full_path = File.expand_path(file)
  puts "#{full_path} -> #{target}"
  if opts[:force] or !File.exist?(target)
    cmd = ["ln", "-sf", "-i", full_path, target]
    pretty_cmd = cmd.map {|x| x =~ /[ ]/ ? x.inspect : x }.join(" ")
    if opts[:dry_run]
      puts "- Would have run: <#{pretty_cmd}>"
    else
      puts "- Running: <#{pretty_cmd}>"
      system(*cmd)
    end
  else
    if opts[:dry_run]
      puts "- Would have skipped since already installed"
    else
      puts "- Skipping #{file}, already installed"
    end
  end
end
