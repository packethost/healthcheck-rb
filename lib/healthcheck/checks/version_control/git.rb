require 'healthcheck/checks/abstract_check'

module Healthcheck
  module Checks
    module VersionControl
      class Git < AbstractCheck
        def initialize(sha = nil)
          @sha = sha
        end

        def ok?
          true
        end

        def report
          result || :unknown
        end

        private

        def perform
          @sha || find_sha_from_git
        end

        def find_sha_from_git
          `git --git-dir="#{Rails.root.join('.git')}" rev-parse --short HEAD`.strip
        rescue
          nil
        end
      end
    end
  end
end
