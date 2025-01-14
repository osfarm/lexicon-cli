# frozen_string_literal: true

module Lexicon
  module Cli
    module Command
      class RemoteCommand < ContainerAwareCommand
        desc 'upload VERSION', 'Uploads the version to the configured S3 storage'

        def upload(version)
          # @type [Package::PackageUploader] uploader
          uploader = get(Lexicon::Common::Remote::PackageUploader)
          # @type [Package::DirectoryPackageLoader]
          loader = get(Lexicon::Common::Package::DirectoryPackageLoader)

          semver = Semantic::Version.new(version) rescue nil

          if semver.nil?
            puts "[ NOK ] #{version} is not a valid version.".red
            exit 1
          elsif (package = loader.load_package(semver.to_s)).nil?
            puts "[ NOK ] No package found for version #{semver}.".red
            exit 1
          else
            result = uploader.upload(package)

            if result.success?
              puts "[  OK ] Version #{semver} uploaded.".green
            else
              puts "[ NOK ] Error while uploading: #{result.error}".red
              log_error(result.error)
              exit 1
            end
          end
        end

        desc 'delete VERSION', 'Deletes a version from the S3 storage'

        def delete(version)
          # @type [Aws::S3::Client] s3
          s3 = get(Lexicon::Common::Remote::S3Client)

          semver = Semantic::Version.new(version) rescue nil

          if semver.nil?
            puts "[ NOK ] #{version} is not a valid version.".red
            exit 1
          else
            bucket = semver.to_s

            if s3.bucket_exist?(bucket)
              s3.ls(bucket)
                .each { |content| s3.raw.delete_object(bucket: bucket, key: content.fetch(:key)) }
              s3.raw.delete_bucket(bucket: bucket)

              puts "[  OK ] The version #{semver} has been deleted from the server".green
            else
              puts "[ NOK ] The version #{semver} does not exist on the server".red
              exit 1
            end
          end
        end

        desc 'ls', 'List remote versions on the server'

        def ls
          # @type [Lexicon::Common::Remote::S3Client] s3
          s3 = get(Lexicon::Common::Remote::S3Client)

          buckets = s3.raw.list_buckets.buckets

          puts 'Present in remote:'
          buckets.each do |b|
            puts "-> #{b.name}"
          end
        end

        desc 'download VERSION', 'Download the given version from the server'

        def download(version)
          # @type [Package::PackageDownloader] uploader
          downloader = get(Lexicon::Common::Remote::PackageDownloader)
          # @type [Package::DirectoryPackageLoader]
          loader = get(Lexicon::Common::Package::DirectoryPackageLoader)

          semver = Semantic::Version.new(version) rescue nil

          if semver.nil?
            puts "[ NOK ] #{version} is not a valid version.".red
            exit 1
          elsif !loader.load_package(semver.to_s).nil?
            puts "[ NOK ] You already have the version #{semver} locally.".red
            exit 1
          else
            result = downloader.download(semver)

            if result.success?
              puts "[  OK ] The version #{semver} has been downloaded."
            else
              puts '[ NOK ] Error while downloading.'.red
              log_error(result.error)
              exit 1
            end
          end
        end
      end
    end
  end
end
