csv_file = File.open('friend_list3.csv', 'r')

key_data= csv_file.gets.chomp.split(",").map {|s| s.to_sym}

csv_data = []

csv_file.each_line do |line|

  new_data= line.chomp.split(',')
  data_hash ={}
  new_data.each_index do|x|
    data_hash.merge!(key_data[x] => new_data[x])
  end

  csv_data.push(data_hash)
end
