# frozen_string_literal: true

using Corindon::DependencyInjection::Injectable

module Lexicon
  module Cli
    module Extension
      class CommonExtension < ExtensionBase
        LOGGER_LEVEL = make_parameter('logger_level')
        PACKAGE_DIR = make_parameter('package_dir')
        PACKAGE_SCHEMA_PATH = make_parameter('package_schema')

        SCHEMA_VALIDATOR = make_definition('schema_validator', factory(Lexicon::Common::Schema::ValidatorFactory, :build))

        def initialize(data_root:)
          @data_root = data_root
        end

        # @param [Corindon::DependencyInjection::Container] container
        def boot(container)
          register_parameters(
            container,
            {
              PACKAGE_SCHEMA_PATH => package_schema_file,
              PACKAGE_DIR => data_root.join('out'),
              LOGGER_LEVEL => Logger::ERROR,
            }
          )
          container.add_definition(Lexicon::Common::Database::Factory)
          container.add_definition(Lexicon::Common::Package::DirectoryPackageLoader) do
            args(CommonExtension::PACKAGE_DIR, schema_validator: CommonExtension::SCHEMA_VALIDATOR)
          end
          container.add_definition(Lexicon::Common::Package::PackageIntegrityValidator) { args(shell: Lexicon::Common::ShellExecutor) }
          container.add_definition(Lexicon::Common::Schema::ValidatorFactory) { args(CommonExtension::PACKAGE_SCHEMA_PATH) }
          container.add_definition(Lexicon::Common::ShellExecutor)
          container.add_definition(Logger) { args(value(STDOUT), level: LOGGER_LEVEL) }
          container.add_definition(SCHEMA_VALIDATOR)

          container.on_service_built(->(service, container) {
            if service.is_a?(Lexicon::Common::Mixin::ContainerAware)
              service.container = container
            end
          })

          container.on_service_built(->(service, container) {
            if service.is_a?(Lexicon::Common::Mixin::LoggerAware)
              service.logger = container.get(Logger)
            end
          })
        end

        def commands
          proc do
            desc 'console', 'Start a console'
            subcommand 'console', Command::ConsoleCommand
          end
        end

        private

          # @return [Pathname]
          attr_reader :data_root

          # @return [Pathname]
          def package_schema_file
            Pathname.new(Gem::Specification.find_by_name('lexicon-common').gem_dir).join(Lexicon::Common::LEXICON_SCHEMA_RELATIVE_PATH)
          end
      end
    end
  end
end
