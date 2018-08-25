require 'lino'
require 'confidante'
require 'rake_terraform'

configuration = Confidante.configuration

RakeTerraform.define_installation_tasks(
    path: File.join(Dir.pwd, 'vendor', 'terraform'),
    version: '0.11.3')

namespace :consul do
  RakeDependencies::Tasks::All.new do |t|
    t.dependency = 'consul'
    t.version = '1.2.2'
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

namespace :domain do
  RakeTerraform.define_command_tasks do |t|
    t.argument_names = [:deployment_identifier, :domain_name]

    t.configuration_name = 'domain'
    t.source_directory = 'infra/domain'
    t.work_directory = 'build'

    t.backend_config = lambda do |args|
      configuration
          .for_overrides(args)
          .for_scope(role: 'domain')
          .backend_config
    end

    t.vars = lambda do |args|
      configuration
          .for_overrides(args)
          .for_scope(role: 'domain')
          .vars
    end
  end
end

namespace :network do
  RakeTerraform.define_command_tasks do |t|
    t.argument_names = [:deployment_identifier]

    t.configuration_name = 'network'
    t.source_directory = 'infra/network'
    t.work_directory = 'build'

    t.backend_config = lambda do |args|
      configuration
          .for_overrides(args)
          .for_scope(role: 'network')
          .backend_config
    end

    t.vars = lambda do |args|
      configuration
          .for_overrides(args)
          .for_scope(role: 'network')
          .vars
    end
  end
end

namespace :cluster do
  RakeTerraform.define_command_tasks do |t|
    t.argument_names = [:deployment_identifier]

    t.configuration_name = 'cluster'
    t.source_directory = 'infra/cluster'
    t.work_directory = 'build'

    t.backend_config = lambda do |args|
      configuration
          .for_overrides(args)
          .for_scope(
              role: 'cluster')
          .backend_config
    end

    t.vars = lambda do |args|
      configuration
          .for_overrides(args)
          .for_scope(role: 'cluster')
          .vars
    end
  end
end

namespace "image_repository" do
  RakeTerraform.define_command_tasks do |t|
    t.argument_names = [:deployment_identifier]

    t.configuration_name = "image repository"
    t.source_directory = "infra/image_repository"
    t.work_directory = 'build'

    t.backend_config = lambda do |args|
      configuration
          .for_overrides(args)
          .for_scope(role: "repository")
          .backend_config
    end

    t.vars = lambda do |args|
      configuration
          .for_overrides(args)
          .for_scope(role: "repository")
          .vars
    end
  end
end
