// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract veracity is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable 
{
    mapping(address=>int) public rating; //Seller => Rating
    mapping(address=>int) public count; //Seller => no of times rated
    mapping(address=>uint) public lastSold; //Seller => time
    mapping(address=>address[]) public ratingQueue; //Buyer => Seller

    uint token;
    address own;
    constructor() ERC721("Veracity", "VRCTY") 
    {
        token=0;
        own=msg.sender;
    }

    function safeMint(string memory uri)public onlyOwner
    {
        _safeMint(own, token);
        _setTokenURI(token, uri);
        token+=1;
    }

    //Enter rating -1 if user does not want to rate it
    function transferFromNew(address _from,address _to, uint256 _tokenId) public
    {
        //require(rate>=-1 && rate<=5);

        require(_from==msg.sender);

        uint last_block_time=block.timestamp;
        require(lastSold[_from]==0 || lastSold[_from]+100<last_block_time);

        transferFrom(_from,_to,_tokenId);

        lastSold[_to]=last_block_time;

        ratingQueue[_to].push(_from);
        /*if(rate!=-1)
        {
            int temp_rating= rating[_from];
            rating[msg.sender]=(temp_rating+rate)/(count[msg.sender]+1);
            count[msg.sender]++;
        }*/
    }

    function giveRating(address seller,int rate) public 
    {
        require(ratingQueue[msg.sender].length>0);
        uint l=ratingQueue[msg.sender].length;
        bool b=false;
        uint i;
        for( i=0;i<uint(l);i++)
        {
            if(ratingQueue[msg.sender][i]==seller)
            {
                b=true;
                break;
            }
        }

        require(b==true);

        int temp_rating=rating[seller];
        rating[seller]=(temp_rating+rate)/(count[seller]+1);
        count[seller]++;

        for(uint j=i+1;j<l;j++)
        {
            ratingQueue[msg.sender][j-1]=ratingQueue[msg.sender][j];
        }
        ratingQueue[msg.sender].pop();

    }

    function getRating(address seller) public view returns(int)
    {
        return rating[seller];
    }

    function getNumberOfRatings(address seller) public view returns(int)
    {
        return count[seller];
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)internal override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) 
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)public view override(ERC721, ERC721URIStorage) returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)public view override(ERC721, ERC721Enumerable) returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
