# frozen_string_literal: true

module Lexicon
  module Cli
    module Command
      class ContainerAwareCommand < Thor
        include Lexicon::Common::Mixin::ContainerAware
        include Lexicon::Common::Mixin::LoggerAware

        def initialize(args = [], local_options = {}, config = {})
          super(args, local_options, config)

          self.container = config[:container]
          self.logger = get(Logger)
        end
      end
    end
  end
end
