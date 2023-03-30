reticulate::install_miniconda()


import requests
from bs4 import BeautifulSoup

url = 'https://civicspark.civicwell.org/2021-22-projects/'
response = requests.get(url)

soup = BeautifulSoup(response.text, 'html.parser')

project_names = []

for project in soup.find_all('h3', class_='title'):
    project_names.append(project.text.strip())

print(project_names)
