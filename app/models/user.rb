require 'httparty'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :topics, through: :research_interests
  has_many :research_interests

  include HTTParty
  base_uri 'https://api.elsevier.com'

  def update_from_scopus
    @api_key = ENV['SCOPUS_API_KEY']
    response = self.class.get('/content/search/author',  query: { query: "authlast(#{last_name}) and authfirst(#{name}) and af-id(60008088)", apiKey: @api_key }).body
    profile = JSON.parse(response)["search-results"]["entry"][0]
    if profile
      publication_count = profile["document-count"] || 0
      self.scopus_id = profile["dc:identifier"] || ""
      @research_interests = profile["subject-area"]
      @research_interests.each do |area|
        existing_topic = Topic.find_by(name: area["$"])
        if existing_topic
          p existing_topic
          research_interests.create(topic: existing_topic)
        else
          topic = Topic.create(name: area["$"])
          p topic
          research_interests.create(topic: topic)
        end
      end
      
    end
  end
  

  def similar
    
  end
end
