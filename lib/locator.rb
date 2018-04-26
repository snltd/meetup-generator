require 'pathname'

def locate_config_ru
  Pathname.new(__FILE__).dirname.parent + 'config.ru'
end
