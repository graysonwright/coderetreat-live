require 'coderetreats/presenters/collection'

module CoderetreatLive
  module Coderetreats
    def self.running_today
      self.for_collection ::Coderetreat.running_today
    end

    def self.for_collection(coderetreats)
      Presenters::Collection.new(coderetreats)
    end

    def self.for_admin_token(token)
      ::Coderetreat.for_admin(token)
    end
  end
end
