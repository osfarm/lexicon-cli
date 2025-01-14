# frozen_string_literal: true

module Lexicon
  module Cli
    class Application
      attr_reader :args

      def initialize(args, extensions: [])
        @args = args
        @extensions = extensions
      end

      def start
        container = Corindon::DependencyInjection::Container.new
        extensions.each do |extension|
          extension.boot(container)
        end

        make_app(extensions).start(args, container: container)
      end

      private

        # @return [Array<Lexicon::Cli::ExtensionBase>]
        attr_reader :extensions

        # @param [Array<Lexicon::Cli::ExtensionBase>]
        # @return [Class]
        def make_app(extensions)
          Class.new(CliBase) do
            extensions.each do |extension|
              if (commands = extension.commands).is_a?(Proc)
                instance_eval(&commands)
              end
            end
          end
        end
    end
  end
end
