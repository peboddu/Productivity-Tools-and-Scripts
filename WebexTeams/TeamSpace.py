#!/usr/bin/env python
import requests
import time


def main():
    # Set the request parameters
    url = 'https://api.ciscospark.com/v1/memberships?roomId=<ROOM_ID_HERE>'
    TOKEN = '<TOKEN_HERE>'

    members = [
        'user@domain.com',

    ]
    roomIds = [
        '<ROOM_ID_HERE>'
    ]

    # Not functional yet (Updating Members)
    # GET: Set proper headers
    ##headers = {"Accept":"application/json", 'Authorization': 'Bearer {}'.format(TOKEN)}
    ##headers = {"Content-Type":"application/json", "Accept":"application/json", 'Authorization': 'Bearer {}'.format(TOKEN)}

    # Do the HTTP request
    ##response = requests.get(url, headers=headers)

    # Decode the JSON response into a dictionary and use the data
    # print('Status:',response.status_code,'Headers:',response.headers)
    ##Response = response.json()
    # for item in (Response['items']):
    ##    url = 'https://api.ciscospark.com/v1/memberships/{}'.format(item['id'])

    # Do the HTTP request
    ##    response = requests.put(url, headers=headers, data='{"isModerator":1}')

    # Decode the JSON response into a dictionary and use the data
    # print('Status:',response.status_code,'Headers:',response.headers)

    # POST: Update Room Membership
    headers = {"Content-Type": "application/json",
               "Accept": "application/json", 'Authorization': 'Bearer {}'.format(TOKEN)}
    url = 'https://api.ciscospark.com/v1/memberships'

    for roomId in roomIds:
        for member in members:
            # Do the HTTP request
            response = requests.post(
                url, headers=headers, data='{"roomId":"%s", "personEmail":"%s"}' % (roomId, member))

            # Decode the JSON response into a dictionary and use the data
            print('Status:', response.status_code,
                  'Headers:', response.headers)


if __name__ == '__main__':
    main()
