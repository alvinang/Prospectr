class TwitterUserSearch < ActiveRecord::Base
  attr_accessible :query, :result
end
