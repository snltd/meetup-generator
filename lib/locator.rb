# frozen_string_literal: true

require 'pathname'

def locate_config_ru
  Pathname.new(__FILE__).dirname.parent.join('config.ru')
end
