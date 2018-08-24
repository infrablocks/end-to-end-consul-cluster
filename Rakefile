require 'confidante'
require 'rake_terraform'

configuration = Confidante.configuration

RakeTerraform.define_installation_tasks(
    path: File.join(Dir.pwd, 'vendor', 'terraform'),
    version: '0.11.3')

namespace :bucket do
  RakeTerraform.define_command_tasks do |t|
    t.argument_names = [:deployment_identifier]

    t.configuration_name = 'state bucket'
    t.source_directory = 'infra/state_bucket'
    t.work_directory = 'build'

    t.state_file = lambda do |args|
      File.join(Dir.pwd, "state/state_bucket/#{args.deployment_identifier}.tfstate")
    end

    t.vars = lambda do |args|
      configuration
          .for_overrides(args)
          .for_scope(role: 'state_bucket')
          .vars
    end
  end
end
