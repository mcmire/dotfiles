#!/usr/bin/env ruby

# Adapted from from Nathan's dotfiles: <https://github.com/aniero/dotfiles/blob/master/install.rb>
# which was originally taken from: <http://errtheblog.com/posts/89-huba-huba>

puts
at_exit { puts }

require 'fileutils'
require 'erb'
require 'optparse'

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
    def file_content
      cyan
    end
  end
else
  String.class_eval do
    %w(dry_success unimportant dry_failure success failure filename file_content).each do |method|
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
Dir["#{SOURCE_DIR}/*"].each do |file|
  source_basename = file.sub("#{SOURCE_DIR}/", "")
  source = File.expand_path(file)
  short_source = source.sub(home, "$HOME")
  target = File.join(home, "." + source_basename).sub(/\.erb$/, "")
  short_target = target.sub(home, "$HOME")
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
  puts "Nothing is being written to the filesystem.".bold.yellow
  puts
end

files.each do |file|
  source_basename, source, short_source, target, short_target = file

  print ("%#{max_file_width}s: " % short_target)
  if options[:force] or !File.exists?(target)
    if File.extname(source) == ".erb"
      template = ERB.new(File.read(source), nil, "-")  # allow <%- ... -%> tags like Rails
      content = template.result(binding).strip
      File.open(target, "w") {|f| f.write(content) } unless options[:dry_run]
      puts "written".success
    else
      target = File.join(home, "." + source_basename)
      FileUtils.ln_s(source, target, :force => true) unless options[:dry_run]
      puts "symlinked".success + " (to #{short_source})".unimportant
    end
  else
    puts "skipped ".failure + "(already installed)".unimportant
  end
end
