require 'sqlite3'
require 'sinatra/activerecord'

ActiveRecord::Base.configurations = YAML.load_file('db/database.yml')
ActiveRecord::Base.establish_connection(:development)

class Content < ActiveRecord::Base
end
class Tag < ActiveRecord::Base
end
class Taglink < ActiveRecord::Base
end
