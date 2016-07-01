namespace :dir do
  desc 'Check if dir exists'
  task exists: :environment do
    log_directory_name = 'log'
    FileUtils.mkdir(log_directory_name) unless File.exists?(log_directory_name)

    pids_directory_name = 'tmp/pids'
    FileUtils.mkdir_p(pids_directory_name) unless File.exists?(pids_directory_name)
  end
end
