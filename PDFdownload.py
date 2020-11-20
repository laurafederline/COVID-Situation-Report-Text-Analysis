# -*- coding: utf-8 -*-
"""
Created on Wed May 13 17:42:42 2020

@author: lafede
"""
from bs4 import BeautifulSoup
import requests
import os

# Get webpage
reports_page = requests.get('https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports')


# Build soup
soup = BeautifulSoup(reports_page.content, 
'html.parser')

# Links dont have the url path so we need this later
path = 'https://www.who.int'

# Find HTML element that contains the list of links
reports_list = soup.find('div', {'id':
'PageContent_C006_Col01'})



# Find all links
url_paths = []
for report in reports_list.findChildren('a', href=True):
    url_paths.append(f"{path}{report['href']}")


# Currently last element in url_paths is a subscription link...removing it
url_paths.pop()

# Print with each path on a new line for readability
# print('\n'.join(url_paths))


## Section 2 - Saving Reports

# Make a reports directory
reports_dir = 'COVID-19 Reports'
# Check to make sure it doesn't already exists or we'll get an error
if not os.path.isdir(reports_dir):
    os.mkdir(reports_dir)



# Download reports
for url in url_paths:
# fancy string (f'') lets run code while making a string to get (semi) readable file names
    file_name = f'{url.split("/")[-1].split("?")[0]}'
    file_path = os.path.join(reports_dir, file_name)
    if not os.path.isfile(file_path):
        report = requests.get(url)
        # Open temporary file buffer in 'w'rite mode for a 'b'inary (not text) file
        with open(file_path, 'wb') as f:
            f.write(report.content) 