import http.client, re

conn = http.client.HTTPSConnection("games.washingtonpost.com")

payload = ""

headers = { 'User-Agent': "insomnia/9.3.3" }

conn.request("GET", "/all-games", payload, headers)

res = conn.getresponse()
data = res.read()

pattern = r'/games/([^"]+)'
games = re.findall(pattern, data.decode("utf-8"))

for game in games:
    conn = http.client.HTTPSConnection("arenacloud.cdn.arkadiumhosted.com")

    payload = "[" + "{" + f"\"slug\":\"{game}\",\"value\":9223372036854775806,\"dateTime\":\"2024-08-11T01:14:34.184Z\"" + "}" + "]"

    headers = {
        'authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjExYjdkNzUxLTYzMmUtNDM3Ny1hNjM0LTMyMDQwMmRhOWQ0ZV93YXNoaW5ndG9ucG9zdCIsInJvbGUiOiJVc2VyIiwiZ2l2ZW5fbmFtZSI6InRoaWV1Y29ucmFkMiIsImVtYWlsIjoiIiwiYXV0aFByb3ZpZGVyIjoid2FzaGluZ3RvbnBvc3QiLCJhcmVuYURvbWFpbiI6ImdhbWVzLndhc2hpbmd0b25wb3N0LmNvbSIsIm5iZiI6MTcyMzMzODc2MCwiZXhwIjoxNzI0MjAyNzYwLCJpYXQiOjE3MjMzMzg3NjAsImlzcyI6Imh0dHBzOi8vYXJlbmEteC1hcGkuYXJrYWRpdW0uY29tLyIsImF1ZCI6Imh0dHBzOi8vYXJlbmEteC5hcmthZGl1bS5jb20vIn0.hT5LOjAlkaKz2EgliwhRe2-hwA-JhCnpViSzxsgWi8I",
        'content-type': "application/json"
    }

    conn.request("POST", "/arenax-51-api-score-live/api/v1/score", payload, headers)

    

    print(conn.getresponse().read().decode("utf-8"))
    print(game)

while True:
    pass