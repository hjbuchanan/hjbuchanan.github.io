require 'csv'
require 'erb'
require 'timerizer'
require 'feedzirra'

require 'mandrill'

$mandrill = Mandrill::API.new 'EIVNuvvqtOBJ2Vt1eTJZMA'

template_email = File.read "email1_friend_email_text.html.erb"

friend_list = CSV.open("friend_list3.csv", :headers => true, :header_converters => :symbol)

atom_path = File.join(Dir.pwd, "../_deploy/atom.xml")
blog_content = Feedzirra::Feed.parse(File.open(atom_path).read)

def send_email (to_name, to_email, from_name, from_email, subject, message_html)
  message_vars = {
    "merge"=>false,
    "from_name"=>from_name,
    "auto_html"=>false,
    "html"=> message_html,
    "track_opens"=>true,
    "tags"=>["fullstack_octomailer_workshop"],
    "preserve_recipients"=>true,
    "from_email"=>from_email,
    "subject"=>subject,
    "to"=>[{"name"=>to_name, "email"=>to_email}],
    "important"=>false
  }

  async = false
  ip_pool = "Main Pool"
  result = $mandrill.messages.send message_vars, async, ip_pool
  #puts message_vars
end
def process_erb (erb_file_path, context_variables)
  message_erb = ERB.new(File.new(erb_file_path).read, nil, "%")
  message_erb.result(context_variables)
end

def get_personal_email_text (first_name, last_name, email, months_since_contact, blog_content)
  context_variables = Kernel.binding()
  message_html = process_erb("email1_friend_email_text.html.erb", context_variables)
end

friend_list.each do |row|
  first_name = row[:first_name]
  last_name = row[:last_name]
  email= row[:email_address]
  months_since_contact = row[:months_since_contact]
  message_html= get_personal_email_text(first_name, last_name, email, months_since_contact, blog_content)

  send_email(first_name, email, "Hannah Jane Buchanan", "hannahbuchanan4@gmail.com", "New Blog Post", message_html)
end
