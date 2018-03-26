import re
import requests
from bs4 import BeautifulSoup

page = requests.get("http://www.imdb.com/title/tt2527336/")

page

soup = BeautifulSoup(page.content, 'html.parser')

all_links = soup.find_all("a")
pattern = re.compile("\/name\/.{1,9}\/[^a-z]|\/title\/.{1,9}\/[^a-z]")

for link in all_links:
    real_link = link.get("href")
    real_link = str(real_link)
    if(pattern.match(real_link)):
        full_link = "http://www.imdb.com" + real_link
        print(full_link)
        new_page = requests.get(full_link)
        new_soup = BeautifulSoup(new_page.content, 'html.parser')
        actor_name_title = new_soup.find("span", class_="itemprop")
        actor_name = actor_name_title.text
        print(actor_name)
    else:
        nothing = "nothing"
#http://www.imdb.com/name/nm1297015/?ref_=nv_cel_dflt_1

