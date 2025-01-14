# frozen_string_literal: true

module Lexicon
  module Cli
    class CliBase < Command::ContainerAwareCommand
      def initialize(args = [], local_options = {}, config = {})
        super(args, local_options, config)

        register_config(container, options)
      end

      default_command :help
      class_option :verbose, type: :boolean, default: false, aliases: ['v']
      class_option :parallel, type: :boolean, default: false, aliases: ['P']

      private

        def register_config(container, options)
          verbose = options['verbose']
          parallel = options['parallel']
          jobs = options.fetch('jobs', parallel ? 4 : 1)

          container.set_parameter('config.verbose', verbose)
          container.set_parameter('config.parallel', parallel)
          container.set_parameter('config.jobs', jobs)
        end
    end
  end
end
