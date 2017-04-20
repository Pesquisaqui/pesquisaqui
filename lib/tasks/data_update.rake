# include 'faraday'
# include 'faraday_middleware'
# include 'JSON'

namespace :data_update do
  desc "TODO"
  task populate: :environment do
    x = Faraday.get 'https://api.elsevier.com/content/search/author?query=af-id(60008088) and SUBJAREA(ENGI)&apiKey=e9945c7d5bba5a4689c948ff8b721bdc&count=200'
    body = JSON.parse x.body
    entries = body["search-results"]["entry"].map do |e|
      first_name = e["preferred-name"]["given-name"]
      last_name = e["preferred-name"]["surname"]
      publication_count = e["document-count"]
      Author.create(first_name: first_name, last_name: last_name, publication_count: publication_count)
    end

    next_link = body["search-results"]["link"].select do |e| e["@ref"] == "next" end
    while next_link.present?
      puts 'Iniciando proxima pagina'
      x = Faraday.get next_link.first["@href"]
      body = JSON.parse x.body
      additional_entries = body["search-results"]["entry"].map do |e|
        first_name = e["preferred-name"]["given-name"]
        last_name = e["preferred-name"]["surname"]
        publication_count = e["document-count"]
        Author.create(first_name: first_name, last_name: last_name, publication_count: publication_count)
      end
      entries.concat(additional_entries)
      next_link = body["search-results"]["link"].select do |e| e["@ref"] == "next" end
    end
    
    puts 'Quantidade total de autores: ', entries.count
  end

end
