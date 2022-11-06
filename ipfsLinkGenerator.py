import requests
url = "https://deep-index.moralis.io/api/v2/ipfs/uploadFolder"
import base64


def generate_ipfs_link():

    with open("ROLEX1.jpeg", "rb") as image_file:
        encoded_string = base64.b64encode(image_file.read()).decode('utf-8')

    #print(encoded_string)

        payload = [
        {
            "path": "ROLEX1.jpeg",
            "content": encoded_string
        }
    ]
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "X-API-Key": "nWkZ3bH2CqwtE2oyO1o7KP35eeGZLVrXWNa2BInrA6VdUz3eo7sstBl4p565KSJy"
    }

    response = requests.post(url,json=payload, headers=headers)

    return response.text


ipfs_url = generate_ipfs_link()
