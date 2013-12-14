require 'rvm2/ui/single'

module Rvm2
  module Ui
    def self.get(type = :console, rvm2_plugins = nil, *args)
      Rvm2::Ui::Single.new(type, rvm2_plugins, *args)
    end
  end
end
