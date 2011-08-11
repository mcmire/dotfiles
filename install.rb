#!/usr/bin/env ruby

# Adapted from from Nathan's dotfiles: <https://github.com/aniero/dotfiles/blob/master/install.rb>
# which was originally taken from: <http://errtheblog.com/posts/89-huba-huba>

puts
at_exit { puts }

require 'fileutils'
require 'erb'
require 'optparse'
require 'pp'

begin
  require 'colored'
  $has_color = true
rescue LoadError
  begin
    require 'rubygems'
    require 'colored'
    $has_color = true
  rescue LoadError => e
    warn "Install the 'colored' gem if you want colors: <gem install colored>"
    warn ""
    $has_color = false
  end
end

if $has_color
  String.class_eval do
    def dry_success
      bold.black
    end
    alias :unimportant :dry_success
    alias :dry_failure :dry_success
    def success
      green
    end
    def failure
      red
    end
    def filename
      bold.blue
    end
    def debugging
      cyan
    end
    def emphasis
      bold.yellow
    end
  end
else
  String.class_eval do
    %w(unimportant dry_success dry_failure success failure filename debugging emphasis).each do |method|
      define_method(method) { self }
    end
  end
end

home = File.expand_path(ENV['HOME'])

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"
  opts.on("-n", "--noop", "--dry-run", "Don't actually copy or write any files.") do |val|
    options[:dry_run] = true
  end
  opts.on("-f", "--force", "Usually dotfiles that already exist are not overwritten, but this will overwrite them.") do |val|
    options[:force] = true
  end
  opts.on("--github-token TOKEN", "Specify your Github API token. It will be placed in .gitconfig.") do |val|
    options[:github_token] = val
  end
  opts.on("-V", "--verbose", "Show commands being run") do |val|
    options[:verbose] = true
  end
  opts.on_tail("-h", "--help") do |val|
    puts parser
  end
end
parser.parse!(ARGV)
if ARGV.any?
  warn "Unknown arguments: #{ARGV.inspect}"
  warn parser
  exit 1
end

SOURCE_DIR = "src"

files = []
Dir["#{SOURCE_DIR}/**/*"].each do |file|
  source_basename = file.sub("#{SOURCE_DIR}/", "")
  source = File.expand_path(file)
  next if File.directory?(source)
  short_source = source.sub(home, "~")
  target = File.join(home, "." + source_basename).sub(/\.erb$/, "")
  short_target = target.sub(home, "~")
  files << [
    source_basename,
    source,
    short_source,
    target,
    short_target
  ]
end
max_file_width = files.map {|f| f[4].length }.max

if options[:dry_run]
  puts "Here's what the output will look like on a 'real' run."
  puts "Nothing is being written to the filesystem.".emphasis
  puts
end

files.each do |file|
  source_basename, source, short_source, target, short_target = file

  print ("%#{max_file_width}s: " % short_target)
  if options[:force] or !File.exists?(target)
    if File.extname(source) == ".erb"
      template = ERB.new(File.read(source), nil, "-")  # allow <%- ... -%> tags like Rails
      content = template.result(binding).strip
      unless options[:dry_run]
        FileUtils.mkdir_p(File.dirname(target))
        File.open(target, "w") {|f| f.write(content) }
      end
      puts "written".success
      puts content.debugging if options[:verbose]
    else
      target = File.join(home, "." + source_basename)
      # Remove the target manually.
      # If it's a regular file, ln -f won't remove it.
      system("rm", "-rf", target)
      cmd = ["ln", "-s", source, target]
      pretty_cmd = cmd.map {|x| x =~ /[ ]/ ? x.inspect : x }.join(" ")
      puts "symlinked".success + " (to #{short_source})".unimportant
      puts pretty_cmd.debugging if options[:verbose]
      unless options[:dry_run]
        FileUtils.mkdir_p(File.dirname(target))
        system(*cmd)
      end
    end
  else
    puts "skipped ".failure + "(already installed)".unimportant
  end
end
