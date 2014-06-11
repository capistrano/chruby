namespace :chruby do
  task :validate do
    on roles(:all) do
      if fetch(:chruby_ruby).nil?
        error "chruby: chruby_ruby is not set"
        exit 1
      end
    end
  end

  task :map_bins do
    chruby_prefix = "#{fetch(:chruby_exec)} #{fetch(:chruby_ruby)} --"
    
    SSHKit.config.command_map[:chruby_prefix] = chruby_prefix

    fetch(:chruby_map_bins).each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(chruby_prefix)
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'chruby:validate'
  after stage, 'chruby:map_bins'
end

namespace :load do
  task :defaults do
    set :chruby_map_bins, %w{rake gem bundle ruby}
    set :chruby_exec, "/usr/local/bin/chruby-exec"
  end
end
