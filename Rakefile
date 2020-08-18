require 'lino'
require 'confidante'
require 'rake_terraform'
require 'rake_docker'

configuration = Confidante.configuration

RakeTerraform.define_installation_tasks(
    path: File.join(Dir.pwd, 'vendor', 'terraform'),
    version: '0.12.28')

namespace :consul do
  RakeDependencies::Tasks::All.new do |t|
    t.dependency = 'consul'
    t.version = '1.8.3'
    t.path = 'vendor/consul'
    t.type = :zip

    t.os_ids = {mac: 'darwin', linux: 'linux'}

    t.uri_template =
        'https://releases.hashicorp.com/consul/<%= @version %>/' +
            'consul_<%= @version %>_<%= @os_id %>_amd64<%= @ext %>'
    t.file_name_template =
        'consul_<%= @version %>_<%= @os_id %>_amd64<%= @ext %>'

    t.needs_fetch = lambda do |parameters|
      terraform_binary = File.join(
          parameters[:path],
          parameters[:binary_directory],
          'consul')
      version_string = StringIO.new

      if File.exist?(terraform_binary)
        Lino::CommandLineBuilder.for_command(terraform_binary)
            .with_flag('-version')
            .build
            .execute(stdout: version_string)

        if version_string.string.lines.first =~ /#{version}/
          return false
        end
      end

      return true
    end
  end
end

namespace :bucket do
  RakeTerraform.define_command_tasks(
      configuration_name: 'state bucket',
      argument_names: [:deployment_identifier]
  ) do |t, args|
    t.source_directory = 'infra/state_bucket'
    t.work_directory = 'build'

    t.state_file =
        File.join(Dir.pwd, "state/state_bucket/#{args.deployment_identifier}.tfstate")

    t.vars = configuration
        .for_overrides(args)
        .for_scope(role: 'state_bucket')
        .vars
  end
end

namespace :domain do
  RakeTerraform.define_command_tasks(
      configuration_name: 'domain',
      argument_names: [:deployment_identifier, :domain_name]
  ) do |t, args|
    t.source_directory = 'infra/domain'
    t.work_directory = 'build'

    t.backend_config = configuration
        .for_overrides(args)
        .for_scope(role: 'domain')
        .backend_config

    t.vars = configuration
        .for_overrides(args)
        .for_scope(role: 'domain')
        .vars
  end
end

namespace :network do
  RakeTerraform.define_command_tasks(
      configuration_name: 'network',
      argument_names: [:deployment_identifier]
  ) do |t, args|
    t.source_directory = 'infra/network'
    t.work_directory = 'build'

    t.backend_config = configuration
        .for_overrides(args)
        .for_scope(role: 'network')
        .backend_config

    t.vars = configuration
        .for_overrides(args)
        .for_scope(role: 'network')
        .vars
  end
end

namespace :service_discovery_cluster do
  RakeTerraform.define_command_tasks(
      configuration_name: 'service discovery cluster',
      argument_names: [:deployment_identifier]
  ) do |t, args|
    t.source_directory = 'infra/cluster'
    t.work_directory = 'build'

    t.backend_config = configuration
        .for_overrides(args)
        .for_scope(role: 'service_discovery_cluster')
        .backend_config

    t.vars = configuration
        .for_overrides(args)
        .for_scope(role: 'service_discovery_cluster')
        .vars
  end
end

namespace :application_cluster do
  RakeTerraform.define_command_tasks(
      configuration_name: 'application cluster',
      argument_names: [:deployment_identifier]
  ) do |t, args|
    t.source_directory = 'infra/cluster'
    t.work_directory = 'build'

    t.backend_config = configuration
        .for_overrides(args)
        .for_scope(role: 'application_cluster')
        .backend_config

    t.vars = configuration
        .for_overrides(args)
        .for_scope(role: 'application_cluster')
        .vars
  end
end

namespace :consul_servers do
  RakeTerraform.define_command_tasks(
      configuration_name: 'consul servers',
      argument_names: [:deployment_identifier]
  ) do |t, args|
    t.source_directory = 'infra/consul_servers'
    t.work_directory = 'build'

    t.backend_config = configuration
        .for_overrides(args)
        .for_scope(role: 'consul_servers')
        .backend_config

    t.vars = configuration
        .for_overrides(args)
        .for_scope(role: 'consul_servers')
        .vars
  end
end

namespace :consul_agents do
  RakeTerraform.define_command_tasks(
      configuration_name: 'consul agents',
      argument_names: [:deployment_identifier]
  ) do |t, args|
    t.source_directory = 'infra/consul_agents'
    t.work_directory = 'build'

    t.backend_config = configuration
        .for_overrides(args)
        .for_scope(role: 'consul_agents')
        .backend_config

    t.vars = configuration
        .for_overrides(args)
        .for_scope(role: 'consul_agents')
        .vars
  end
end
