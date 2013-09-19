require 'csv'

template_email = File.read "email1_friend_email_text.html"

friend_list = CSV.open("friend_list3.csv", :headers => true, :header_converters => :symbol)

array_of_hash=[]

friend_list.each do |row| friend_hash= {}
   row.each do |i|
    friend_hash[i[0]] = i[1]
end
  array_of_hash.push(friend_hash)
end

