import os
import requests
import json
import urllib3
def lambda_handler(event, context):
    url = "https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data"
    headers = {
        "X-Siemens-Auth": "test"
    }
    payload = {
        "subnet_id": os.environ.get("subnet_id"),
        "name": "subhashini.dasam",
        "email": "dasamsubhashini1998@gmail.com"
    }

    response = requests.post(url, headers=headers, json=payload)
    return response.json()


