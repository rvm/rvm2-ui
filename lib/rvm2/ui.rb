module Rvm2
  module Ui
    def self.get(type = :console, rvm2_plugins = nil, *args)
      Rvm2::Ui::Single.new(type, rvm2_plugins, *args)
    end
    def self.multi(rvm2_plugins = nil)
      Rvm2::Ui::Multi.new(rvm2_plugins)
    end
  end
end

require_relative 'ui/single'
require_relative 'ui/multi'
