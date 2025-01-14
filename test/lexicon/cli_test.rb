require 'test_helper'

module Lexicon
  class CliTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Lexicon::Cli::VERSION
    end
  end
end
