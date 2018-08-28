require 'lino'
require 'confidante'
require 'rake_terraform'
require 'rake_docker'

require_relative 'lib/terraform_output'
require_relative 'lib/version'

configuration = Confidante.configuration
version = Version.from_file('build/version')

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

namespace "image" do
  RakeDocker.define_image_tasks do |t|
    t.argument_names = [:deployment_identifier]

    t.image_name = "consul"
    t.work_directory = 'build/images'

    t.copy_spec = [
        "src/consul/Dockerfile",
        "src/consul/entrypoint.sh"
    ]

    t.create_spec = [
        {content: version.to_s, to: 'VERSION'},
        {content: version.to_docker_tag, to: 'TAG'}
    ]

    t.repository_name = "infrablocks/consul"

    t.repository_url = lambda do |args|
      backend_config =
          configuration
              .for_overrides(args)
              .for_scope(role: "repository")
              .backend_config

      TerraformOutput.for(
          name: 'repository_url',
          source_directory: "infra/image_repository",
          work_directory: 'build',
          backend_config: backend_config)
    end

    t.credentials = lambda do |args|
      backend_config =
          configuration
              .for_overrides(args)
              .for_scope(role: "repository")
              .backend_config

      region =
          configuration
              .for_overrides(args)
              .for_scope(role: "repository")
              .region

      authentication_factory = RakeDocker::Authentication::ECR.new do |c|
        c.region = region
        c.registry_id = TerraformOutput.for(
            name: 'registry_id',
            source_directory: "infra/image_repository",
            work_directory: 'build',
            backend_config: backend_config)
      end

      authentication_factory.call
    end

    t.tags = [version.to_docker_tag, 'latest']
  end

  desc 'Build and push custom concourse image'
  task :publish, [:deployment_identifier] do |_, args|
    Rake::Task["image:clean"].invoke(args.deployment_identifier)
    Rake::Task["image:build"].invoke(args.deployment_identifier)
    Rake::Task["image:tag"].invoke(args.deployment_identifier)
    Rake::Task["image:push"].invoke(args.deployment_identifier)
  end
end
