class Topic < ApplicationRecord
  has_many :research_interests
  has_many :users, through: :research_interests
end
