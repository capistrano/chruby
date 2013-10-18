def bundler_loaded?
  Gem::Specification::find_all_by_name('capistrano-bundler').any?
end

namespace :deploy do
  before :starting, :hook_chruby_bins do
    invoke :'chruby:check'
    invoke :'chruby:command_map'
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

  task :command_map do
    on roles(:all) do
      fetch(:chruby_map_bins).each do |bin|
        prefix = "#{fetch(:chruby_exec)} #{fetch(:chruby_ruby)} --"
        bundle_exec = bundler_loaded? && bin.to_s != "bundle"
        SSHKit.config.command_map[bin.to_sym] = if bundle_exec
          "#{prefix} bundle exec #{bin}"
        else
          "#{prefix} #{bin}"
        end
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
