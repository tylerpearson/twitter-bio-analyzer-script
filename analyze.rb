require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "ADD ME"
  config.consumer_secret     = "ADD ME"
  config.access_token        = "ADD ME"
  config.access_token_secret = "ADD ME"
end

USERNAME = "tylerpearson"

stop_words = ["a", "able", "about", "across", "after", "all", "almost", "also", "am", "among", "an", "and", "any", "are", "as", "at", "be", "because", "been", "but", "by", "can", "cannot", "could", "dear", "did", "do", "does", "either", "else", "ever", "every", "for", "from", "get", "got", "had", "has", "have", "he", "her", "hers", "him", "his", "how", "however", "i", "if", "in", "into", "is", "it", "its", "just", "least", "let", "like", "likely", "may", "me", "might", "most", "must", "my", "neither", "no", "nor", "not", "of", "off", "often", "on", "only", "or", "other", "our", "own", "rather", "said", "say", "says", "she", "should", "since", "so", "some", "than", "that", "the", "their", "them", "then", "there", "these", "they", "this", "tis", "to", "too", "twas", "us", "wants", "was", "we", "were", "what", "when", "where", "which", "while", "who", "whom", "why", "will", "with", "would", "yet", "you", "your", "ain't", "aren't", "can't", "could've", "couldn't", "didn't", "doesn't", "don't", "hasn't", "he'd", "he'll", "he's", "how'd", "how'll", "how's", "i'd", "i'll", "i'm", "i've", "isn't", "it's", "might've", "mightn't", "must've", "mustn't", "shan't", "she'd", "she'll", "she's", "should've", "shouldn't", "that'll", "that's", "there's", "they'd", "they'll", "they're", "they've", "wasn't", "we'd", "we'll", "we're", "weren't", "what'd", "what's", "when'd", "when'll", "when's", "where'd", "where'll", "where's", "who'd", "who'll", "who's", "why'd", "why'll", "why's", "won't", "would've", "wouldn't", "you'd", "you'll", "you're", "you've"]

accounts = []

client.follower_ids(USERNAME).each { |id| accounts << id }
client.friend_ids(USERNAME).each { |id| accounts << id }

client.list_members.each_with_index do |member, index|
  accounts << member.id
end

# client.list_members('nytimes', 'nyt-journalists').each { |id| accounts << id }

accounts_info = client.users(accounts)

words = []

accounts_info.each_with_index do |follower, index|
  description = follower.description
  description.downcase.gsub(',', '').gsub('.', '').gsub('(', '').gsub(')', '').gsub(':', '').split(' ').each do |word|
    words << word
  end
end

results = Hash.new(0)

words.each do |word|
  next if stop_words.include?(word)
  next if word.length == 1
  results[word] += 1
end

md_doc = ""
results = results.sort_by { |word, usage_count| usage_count }.reverse.map do |result|
  if result.last > 1
    info = "#{result.first}: #{result.last}\n"
    puts info
    md_doc << info
  end
end

File.open("results/#{USERNAME}.md","w") do |f|
  f.write(md_doc)
end
