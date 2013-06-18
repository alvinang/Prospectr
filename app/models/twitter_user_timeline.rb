class TwitterUserTimeline < ActiveRecord::Base
  attr_accessible :query, :result
end
