ENV[ "BUNDLE_GEMFILE" ] ||= File.expand_path "../../Gemfile" , __FILE__

unless defined? Bundler
  begin
    require "bundler"
  rescue
    require "rubygems"
    require "bundler"
  ensure
    Bundler.setup
  end
end
