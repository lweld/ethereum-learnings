# This program fetches an object of arrays of data, parses it, sums
# the data values and depending on the sum a certain bonus is given.

import json
import urllib.request
import certifi

def getResults():
    response = urllib.request.urlopen("https://wt-19530e90680cc09cb0b8e139b494d0f1-0.run.webtask.io/computation_data", cafile=certifi.where())
    html = response.readlines()
    parsedResult = json.loads(html[0])
    output = 0
    float(output)
    for i in parsedResult['results']:
        output += i
    return round(output)

def bonus(earnings):
    if earnings > 346:
        return 100
    elif 346 >= earnings > 314:
        return 70
    elif 314 >= earnings > 301:
        return 50
    elif 301 >= earnings > 290:
        return 30
    else:
        return 20

def main():
    earnings = getResults()
    print(bonus(earnings))
main()
