####################
# MindFlow Scrapper
####################

# Libraries import / Import das bibliotecas
import requests
from bs4 import BeautifulSoup

# Get lyrics in letras site / Buscar letra no site do Letras BR
page = requests.get("https://www.letras.mus.br/mindflow/1343943/")

# Parsing HTML / Parseamento do HTML
soup = BeautifulSoup(page.content, 'html.parser')

# Get the frame where the music are located in page / Busca a classe do frame onde está a letra
lyric = soup.find('div', class_='cnt-letra')

# Variable to split the paragraphs / Variável para dividir os parágrafos
paragraphs = lyric.find_all('p')

# Lista de texto que para cada letra P (paragrafos) e para cada linha (p.contents) vai fazet a quebra de linha
text_list = []
for p in paragraphs:
    for line in p.contents:
        if str(line) != '<br/>':
            text_list.append(str(line))
                
# Letra completa
text_list


