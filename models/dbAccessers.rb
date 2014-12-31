require 'sqlite3'
require 'sinatra/activerecord'

ActiveRecord::Base.configurations = YAML.load_file('db/database.yml')
ActiveRecord::Base.establish_connection(:development)

class Post < ActiveRecord::Base
end
class Tag < ActiveRecord::Base
  has_many :taglinks
end
class Taglink < ActiveRecord::Base
  #belongs_to :post
  belongs_to :tag
end
