# frozen_string_literal: true

using Corindon::DependencyInjection::Injectable

module Lexicon
  module Cli
    module Extension
      class ProductionExtension < ExtensionBase
        DATABASE_URL = make_parameter('database_url')

        DATABASE = make_definition('database', factory(Lexicon::Common::Database::Factory, :new_instance), url: DATABASE_URL)

        def boot(container)
          register_parameters(
            container,
            {
              DATABASE_URL => database_url
            }
          )

          container.add_definition(Lexicon::Common::Production::FileLoader) do
            args(shell: Lexicon::Common::ShellExecutor, database_url: ProductionExtension::DATABASE_URL)
          end
          container.add_definition(Lexicon::Common::Production::TableLocker) do
            args(
              database_factory: Lexicon::Common::Database::Factory,
              database_url: ProductionExtension::DATABASE_URL,
            )
          end
          container.add_definition(Lexicon::Common::Production::DatasourceLoader) do
            args(
              shell: Lexicon::Common::ShellExecutor,
              database_factory: Lexicon::Common::Database::Factory,
              file_loader: Lexicon::Common::Production::FileLoader,
              database_url: ProductionExtension::DATABASE_URL,
              table_locker: Lexicon::Common::Production::TableLocker,
              psql: Lexicon::Common::Psql,
            )
          end
          container.add_definition(Lexicon::Common::Psql) do
            args(
              url: ProductionExtension::DATABASE_URL,
              executor: Lexicon::Common::ShellExecutor,
            )
          end
          container.add_definition(DATABASE)
        end

        def commands
          proc do
            desc 'production', 'Production related commands'
            subcommand 'production', Command::ProductionCommand
          end
        end

        private

          def database_url
            user = ENV.fetch('PRODUCTION_DATABASE_USER', 'postgres')
            password = ENV.fetch('PRODUCTION_DATABASE_PASSWORD', nil)
            host = ENV.fetch('PRODUCTION_DATABASE_HOST', '127.0.0.1')
            port = ENV.fetch('PRODUCTION_DATABASE_PORT', '5432')
            name = ENV.fetch('PRODUCTION_DATABASE_NAME', 'lexicon')

            credentials = if password.nil?
                            user
                          else
                            "#{user}:#{password}"
                          end

            "postgres://#{credentials}@#{host}:#{port}/#{name}"
          end
      end
    end
  end
end
