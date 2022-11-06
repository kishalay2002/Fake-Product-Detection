from ipfsLinkGenerator import generate_ipfs_link
from web3 import Web3
import json
import os
import getpass

file = open('abi', 'r')
ABI = json.load(file)
file.close()

# creating the Application


class application:

    def __init__(self):
        self.w3 = Web3(Web3.HTTPProvider(
            'https://goerli.infura.io/v3/d07081668ab546a8b05e70750a9476be'))
        self.contract_instance = self.w3.eth.contract(
            '0xe1006893515FEbDd6dE08101DC7C348CED987271', abi=ABI)
        self.owner = '0xF617EDcaB89f694112e60C7ba532E21267f38E5d'

    # Checks authenticity of a productcd cd
    def checkTokenID(self, TokenID: int):

        token_owner = self.contract_instance.functions.ownerOf(TokenID).call()
        ipfs_url = self.contract_instance.functions.tokenURI(TokenID).call()
        seller_rating = self.contract_instance.functions.getRating(
            token_owner).call()
        total_number_of_ratings = self.contract_instance.functions.getNumberOfRatings(
            token_owner).call()

        print("Owner: ", token_owner)
        print("Seller Rating: ", seller_rating,
              " (", total_number_of_ratings, ") ")
        print("IPFS URL: \n", ipfs_url)
        # return (ipfs, seller_rating, total_number_of_ratings)
        # Selling the product and storing Address of New Buyer

    def sellProduct(self, buyerAddress: str, TokenID: int):

        token_owner = self.contract_instance.functions.ownerOf(TokenID).call()
        private_key = getpass.getpass(
            f"Enter the private key of {token_owner}: ")
        tx = self.contract_instance.functions.transferFromNew(token_owner, buyerAddress, TokenID).buildTransaction(
            {'from': token_owner, 'nonce': self.w3.eth.get_transaction_count(token_owner)})
        tx_create = self.w3.eth.account.sign_transaction(tx, private_key)
        tx_hash = self.w3.eth.send_raw_transaction(tx_create.rawTransaction)
        tx_receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        print("Transaction successful ")
        print("New Owner: ", buyerAddress)

    def reviewSeller(self, sellerAddress, rating, tokenID: int):
        token_owner = self.contract_instance.functions.ownerOf(tokenID).call()
        private_key = getpass.getpass(
            f"Enter the private key of {token_owner}: ")
        tx = self.contract_instance.functions.giveRating(sellerAddress, rating).buildTransaction(
            {'from': token_owner, 'nonce': self.w3.eth.get_transaction_count(token_owner)})
        tx_create = self.w3.eth.account.sign_transaction(tx, private_key)
        tx_hash = self.w3.eth.send_raw_transaction(tx_create.rawTransaction)
        tx_receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)

        seller_rating = self.contract_instance.functions.getRating(
            sellerAddress).call()
        print(f"New Seller Rating: {seller_rating}")

    def sellerRating(self, sellerAddress: str):

        rating = self.contract_instance.functions.getRating(
            sellerAddress).call()
        no = self.contract_instance.functions.getNumberOfRatings(
            sellerAddress).call()

        print(f"Rating: {rating} ({no})")

        # Creating the Product

    def productCreation(self):

        ipfs_url = generate_ipfs_link()
        private_key = getpass.getpass(f"Enter private key of {self.owner}: ")
        tx = self.contract_instance.functions.safeMint(ipfs_url).buildTransaction(
            {'from': self.owner, 'nonce': self.w3.eth.get_transaction_count(self.owner)})
        tx_create = self.w3.eth.account.sign_transaction(tx, private_key)
        tx_hash = self.w3.eth.send_raw_transaction(tx_create.rawTransaction)
        tx_receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)
        total_supply = self.contract_instance.functions.totalSupply().call()
        # url = "https://ipfs.moralis.io:2053/ipfs/" + ipfs
        print("Token ID: ", total_supply - 1)
        print("IPFS URL: \n", ipfs_url)


def main():
    # tknID = int(input("Enter Token ID of the Product: "))
    app = application()
    # product_details = app.checkTokenID(tknID)

    os.system("clear")
    # tknID = int(input("Enter Token ID of the Product: "))

    # options = ['Owner', 'Seller Rating',
    # 'Total Number of Seller Rating', 'IPFS URL']
    print("\033[1;33m MENU CHART\n-------------")
    print("\033[1;33m 1. Product Creation")
    print("\033[1;33m 2. Check Product Authenticity")
    print("\033[1;33m 3. Sell Product")
    print("\033[1;33m 4. Review Seller")
    print("\033[1;33m 5. Get  Seller Review")

    key = int(input("Enter your choice :"))
    if (key == 1):
        app.productCreation()
    elif (key == 2):
        tknID = int(input("Enter Token ID of the Product: "))
        app.checkTokenID(tknID)
    elif (key == 3):
        buyerAddress = input("Enter Address of Buyer : ")
        tknID = int(input("Enter Token ID of the Product: "))
        app.sellProduct(buyerAddress, tknID)
    elif (key == 4):
        tokenID = int(input("Enter Token ID :"))
        sellerAddr = input("Seller Address: ")
        rating = int(input("Enter Rating :"))

        app.reviewSeller(sellerAddr, rating, tokenID)
    elif (key == 5):
        sellerAdr = input("Enter Seller Address: ")
        app.sellerRating(sellerAdr)
    else:
        print("Wrong Input!!!")

    choice = input("Enter Y/y to continue or N/n to exit ")

    if (choice == 'Y' or choice == 'y'):
        os.system("clear")
        return
    else:
        os.system("clear")
        os._exit(0)

    # url where product details is stored :
    # print(url)
while True:
    main()
