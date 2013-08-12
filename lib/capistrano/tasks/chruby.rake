def bundler_loaded?
  Gem::Specification::find_all_by_name('capistrano-bundler').any?
end

SSHKit.config.command_map = Hash.new do |hash, key|
  if fetch(:chruby_map_bins).include?(key.to_s)
    prefix = "#{fetch(:chruby_exec)} #{fetch(:chruby_ruby)} --"
    hash[key] = if bundler_loaded? && key.to_s != "bundle"
      "#{prefix} bundle exec #{key}"
    else
      "#{prefix} #{key}"
    end
  else
    hash[key] = key
  end
end

namespace :deploy do
  before :starting, :hook_chruby_bins do
    invoke :'chruby:check'
  end
end

namespace :chruby do
  task :check do
    on roles(:all) do
      chruby_ruby = fetch(:chruby_ruby)
      if chruby_ruby.nil?
        error "chruby: chruby_ruby is not set"
        exit 1
      end
    end
  end
end

namespace :load do
  task :defaults do
    set :chruby_map_bins, %w{rake gem bundle ruby}
    set :chruby_exec, "/usr/local/bin/chruby-exec"
  end
end
