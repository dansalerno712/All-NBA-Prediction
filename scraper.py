import requests
from bs4 import BeautifulSoup
import time
import sys

# per36 all stars
# url = "https://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&type=per_minute&per_minute_base=36&per_poss_base=100&lg_id=NBA&is_playoffs=N&year_min=1980&year_max=&franch_id=&season_start=1&season_end=-1&age_min=0&age_max=99&shoot_hand=&height_min=0&height_max=99&birth_country_is=Y&birth_country=&birth_state=&college_id=&draft_year=&is_active=&debut_yr_nba_start=&debut_yr_nba_end=&is_hof=&is_as=Y&as_comp=gt&as_val=0&award=&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&qual=&c1stat=g&c1comp=gt&c1val=40&c2stat=&c2comp=&c2val=&c3stat=&c3comp=&c3val=&c4stat=&c4comp=&c4val=&c5stat=&c5comp=&c6mult=&c6stat=&order_by=season&order_by_asc=&offset="

# per36 all nba
# url = "https://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&type=per_minute&per_minute_base=36&per_poss_base=100&season_start=1&season_end=-1&lg_id=NBA&age_min=0&age_max=99&is_playoffs=N&height_min=0&height_max=99&year_min=1980&birth_country_is=Y&as_comp=gt&as_val=0&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&award=all-nba-n&c1stat=g&c1comp=gt&c1val=40&order_by=season&offset=0"

# per36 all nba but not all star
# url = "https://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&type=per_minute&per_minute_base=36&per_poss_base=100&season_start=1&season_end=-1&lg_id=NBA&age_min=0&age_max=99&is_playoffs=N&height_min=0&height_max=99&year_min=1980&birth_country_is=Y&is_as=N&as_comp=gt&as_val=0&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&award=all-nba-n&c1stat=g&c1comp=gt&c1val=40&order_by=season&offset="

# advanced all stars
# url = "https://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&per_minute_base=36&per_poss_base=100&type=advanced&season_start=1&season_end=-1&lg_id=NBA&age_min=0&age_max=99&is_playoffs=N&height_min=0&height_max=99&year_min=1980&birth_country_is=Y&is_as=Y&as_comp=gt&as_val=0&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&c1stat=g&c1comp=gt&c1val=40&order_by=season&offset=0"

# advanced all nba
# url = "https://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&per_minute_base=36&per_poss_base=100&type=advanced&season_start=1&season_end=-1&lg_id=NBA&age_min=0&age_max=99&is_playoffs=N&height_min=0&height_max=99&year_min=1980&birth_country_is=Y&as_comp=gt&as_val=0&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&award=all-nba-n&c1stat=g&c1comp=gt&c1val=40&order_by=season&offset="

# advanced all nba but not all star
# url = "https://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&per_minute_base=36&per_poss_base=100&type=advanced&season_start=1&season_end=-1&lg_id=NBA&age_min=0&age_max=99&is_playoffs=N&height_min=0&height_max=99&year_min=1980&birth_country_is=Y&is_as=N&as_comp=gt&as_val=0&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&award=all-nba-n&c1stat=g&c1comp=gt&c1val=40&order_by=season&offset="

# team data
# url = "https://www.basketball-reference.com/play-index/tsl_finder.cgi?request=1&match=single&type=team_totals&year_min=1980&lg_id=NBA&order_by=wins&offset="

if len(sys.argv) != 3:
    print("Usage: python scraper <url> <filname>")
url = sys.argv[1]

url += "&offset="

offset = 0
table_headers = []
data = []
while (True):
    # print("Scraping offset: " + str(offset))
    r = requests.get(url + str(offset))
    soup = BeautifulSoup(r.content, "lxml")
    table = soup.find("table", attrs={"id": "stats"})

    if table is None:
        flag = True
        break

    if len(table_headers) == 0:
        th = table.find("thead")
        rows = th.find_all("tr", attrs={"class": ""})
        for row in rows:
            headers = row.find_all("th")
            headers = [ele.text.strip() for ele in headers]
            table_headers.extend(headers)

    table_body = table.find("tbody")
    rows = table_body.find_all("tr")
    for row in rows:
        cols = row.find_all("td")
        cols = [ele.text.strip(" *") for ele in cols]
        if len(cols) > 0:
            data.append(cols)

    offset += 100

table_headers.remove("Rk")
to_file = ""
to_file += ",".join(table_headers) + "\n"

for row in data:
    to_file += ",".join(row) + "\n"


file_name = sys.argv[2]
# file_name = "teamdata.csv"
f = open(file_name, "w")
f.write(to_file)
f.close()
