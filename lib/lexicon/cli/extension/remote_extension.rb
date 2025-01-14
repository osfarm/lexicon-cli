# frozen_string_literal: true

module Lexicon
  module Cli
    module Extension
      class RemoteExtension < ExtensionBase
        # @param [Corindon::DependencyInjection::Container] container
        def boot(container)
          register_parameters(
            container,
            {
              'lexicon.common.remote.endpoint' => ENV.fetch('MINIO_HOST', 'https://io.ekylibre.dev'),
              'lexicon.common.remote.access_key_id' => ENV.fetch('MINIO_ACCESS_KEY', nil),
              'lexicon.common.remote.secret_access_key' => ENV.fetch('MINIO_SECRET_KEY', nil),
              'lexicon.common.remote.force_path_style' => true,
              'lexicon.common.remote.region' => 'us-east-1',
            }
          )

          container.add_definition(Lexicon::Common::Remote::PackageDownloader) do
            args(
              s3: Lexicon::Common::Remote::S3Client,
              out_dir: CommonExtension::PACKAGE_DIR,
              package_loader: Lexicon::Common::Package::DirectoryPackageLoader
            )
          end
          container.add_definition(Lexicon::Common::Remote::PackageUploader) { args(s3: Lexicon::Common::Remote::S3Client) }
          container.add_definition(Lexicon::Common::Remote::S3Client) { args(raw: Aws::S3::Client) }
          container.add_definition(Aws::S3::Client) do
            args(
              endpoint: param('lexicon.common.remote.endpoint'),
              access_key_id: param('lexicon.common.remote.access_key_id'),
              secret_access_key: param('lexicon.common.remote.secret_access_key'),
              force_path_style: param('lexicon.common.remote.force_path_style'),
              region: param('lexicon.common.remote.region'),
            )
          end
        end

        def commands
          proc do
            desc 'remote', 'Minio related commands'
            subcommand 'remote', Command::RemoteCommand
          end
        end
      end
    end
  end
end
