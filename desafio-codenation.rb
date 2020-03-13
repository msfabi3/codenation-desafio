# 1- fazer uma requisicao HTTP para a url abaixo:
# https://api.codenation.dev/v1/challenge/dev-ps/generate-data?token=979ae14e72b24545e6b240f245364ede8cfa4f3d
# 2- salvar o conteúdo do JSON em um arquivo com o nome answer.json
# 3- pegar o número de casas para decifrar o texto
# 4- criar um método para decifrar o texto
# 5- atualizar o arquivo JSON, no campo decifrado
# 6- gerar um resumo criptográfico do texto decifrado usando o algoritmo sha1
# 7- atualizar novamente o arquivo JSON
# 8- pegar o arquivo atualizado para fazer via POST
# https://api.codenation.dev/v1/challenge/dev-ps/submit-solution?token=979ae14e72b24545e6b240f245364ede8cfa4f3d
# 1- fazer uma requisicao HTTP para a url abaixo:
# https://api.codenation.dev/v1/challenge/dev-ps/generate-data?token=979ae14e72b24545e6b240f245364ede8cfa4f3d
# 2- salvar o conteúdo do JSON em um arquivo com o nome answer.json
# 3- pegar o número de casas para decifrar o texto
# 4- criar um método para decifrar o texto
# 5- atualizar o arquivo JSON, no campo decifrado
# 6- gerar um resumo criptográfico do texto decifrado usando o algoritmo sha1
# 7- atualizar novamente o arquivo JSON
# 8- pegar o arquivo atualizado para fazer via POST
# 
# 1- separar a mensagem em letras
#2- verificar se está no alfabeto
#3- if ela estiver no alfa, tem que ir number casas pra frente usando o index se pa o eache with index
#4- se nao estiver no alfa, mantem o caracter
require 'net/http'
require 'json'
require 'pry'
require 'digest/sha1'
def decrypt(number, message)
  alphabet = ('a'..'z').to_a
  result_string = ""
  message.each_char do |letter|
    if alphabet.include? letter
      letter_index = alphabet.index(letter)
      new_index = letter_index - number
      letter = alphabet[new_index]
    end
    result_string << letter
  end
  p result_string
  return result_string
end
def write_json(response_hash)
   File.open("answer.json", "w") do |f|
    f.write(response_hash.to_json)
  end
end
url = 'https://api.codenation.dev/v1/challenge/dev-ps/generate-data?token=979ae14e72b24545e6b240f245364ede8cfa4f3d'
uri = URI(url)
response = Net::HTTP.get(uri)
response_hash = JSON.parse(response)
house_number = response_hash["numero_casas"]
cyphered_message = response_hash["cifrado"].downcase
decripted_message = decrypt(house_number, cyphered_message)
response_hash["decifrado"] = decripted_message
response_hash["resumo_criptografico"] = Digest::SHA1.hexdigest decripted_message
write_json(response_hash)
post_uri = URI('https://api.codenation.dev/v1/challenge/dev-ps/submit-solution?token=979ae14e72b24545e6b240f245364ede8cfa4f3d')
request = Net::HTTP::Post.new(post_uri)
form_data = [['answer', File.open("answer.json")]] # or File.open() in case of local file
request.set_form form_data, 'multipart/form-data'
response = Net::HTTP.start(post_uri.hostname, post_uri.port, use_ssl: true) do |http| # pay attention to use_ssl if you need it
  http.request(request)
end
p response
p response.body