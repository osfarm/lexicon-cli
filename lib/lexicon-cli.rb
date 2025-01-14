# frozen_string_literal: true

require 'corindon'
require 'lexicon-common'
require 'thor'
require 'zeitwerk'

# Make sure the Lexicon module already exists so that Zeitwerk does not manage it
module Lexicon
end

loader = Zeitwerk::Loader.for_gem
loader.ignore(__FILE__)
loader.setup
