echo "Scraping Per 36"
python -u scraper.py "https://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&type=per_minute&per_minute_base=36&per_poss_base=100&season_start=1&season_end=-1&lg_id=NBA&age_min=0&age_max=99&is_playoffs=N&height_min=0&height_max=99&year_min=1980&birth_country_is=Y&is_as=Y&as_comp=gt&as_val=0&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&order_by=season" per36allstars.csv
python -u scraper.py "https://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&type=per_minute&per_minute_base=36&per_poss_base=100&season_start=1&season_end=-1&lg_id=NBA&age_min=0&age_max=99&is_playoffs=N&height_min=0&height_max=99&year_min=1980&birth_country_is=Y&as_comp=gt&as_val=0&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&award=all-nba-n&order_by=season" per36allnba.csv

echo "Scraping Per 100"
python -u scraper.py "https://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&per_minute_base=36&type=per_poss&per_poss_base=100&season_start=1&season_end=-1&lg_id=NBA&age_min=0&age_max=99&is_playoffs=N&height_min=0&height_max=99&year_min=1980&birth_country_is=Y&is_as=Y&as_comp=gt&as_val=0&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&order_by=season" per100allstars.csv
python -u scraper.py "https://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&per_minute_base=36&type=per_poss&per_poss_base=100&season_start=1&season_end=-1&lg_id=NBA&age_min=0&age_max=99&is_playoffs=N&height_min=0&height_max=99&year_min=1980&birth_country_is=Y&as_comp=gt&as_val=0&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&award=all-nba-n&order_by=season" per100allnba.csv

echo "Scraping Advanced"

python -u scraper.py "https://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&per_minute_base=36&per_poss_base=100&type=advanced&season_start=1&season_end=-1&lg_id=NBA&age_min=0&age_max=99&is_playoffs=N&height_min=0&height_max=99&year_min=1980&birth_country_is=Y&is_as=Y&as_comp=gt&as_val=0&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&order_by=season" advancedallstars.csv
python -u scraper.py "https://www.basketball-reference.com/play-index/psl_finder.cgi?request=1&match=single&per_minute_base=36&per_poss_base=100&type=advanced&season_start=1&season_end=-1&lg_id=NBA&age_min=0&age_max=99&is_playoffs=N&height_min=0&height_max=99&year_min=1980&birth_country_is=Y&as_comp=gt&as_val=0&pos_is_g=Y&pos_is_gf=Y&pos_is_f=Y&pos_is_fg=Y&pos_is_fc=Y&pos_is_c=Y&pos_is_cf=Y&award=all-nba-n&order_by=season" advancedallnba.csv

echo "Scraping Team Data"

python -u scraper.py "https://www.basketball-reference.com/play-index/tsl_finder.cgi?request=1&match=single&type=team_totals&year_min=1980&lg_id=NBA&order_by=season" teamdata.csv

read -p "Done! Press any key to continue... " -n1 -s
