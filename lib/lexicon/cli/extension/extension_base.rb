# frozen_string_literal: true

module Lexicon
  module Cli
    module Extension
      class ExtensionBase
        # @param [Corindon::DependencyInjection::Container] container
        def boot(container) end

        def commands; end

        private

          # @param [Corindon::DependencyInjection::Container] container,
          # @param [Hash<String=>Object>] parameters
          def register_parameters(container, parameters = {})
            parameters.each { |k, v| container.set_parameter(k, v) }
          end

          # @param [Corindon::DependencyInjection::Container] container
          # @param [Array<Class>] services
          def register_all(*services, container:)
            services.each { |s| container.add_definition(s) }
          end
      end
    end
  end
end
