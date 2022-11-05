// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract veracity is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable 
{
    mapping(address=>int) public rating;
    mapping(address=>int) public count;
    mapping(address=>uint) public lastSold;
    constructor() ERC721("Veracity", "VRCTY") 
    {}

    function safeMint(address to, uint256 tokenId, string memory uri)public onlyOwner
    {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    //Enter rating -1 if user does not want to rate it
    function transferFromNew(address _from,address _to, uint256 _tokenId,int rate) public
    {
        uint last_block_time=block.timestamp;
        require(rate>=-1 && rate<=5);
        require(_from==msg.sender);
        require(lastSold[_from]==0 || lastSold[_from]+100<last_block_time);
        transferFrom(_from,_to,_tokenId);
        lastSold[_to]=last_block_time;
        //require(b);
        if(rate!=-1)
        {
            int temp_rating= rating[_from];
            rating[msg.sender]=(temp_rating+rate)/(count[msg.sender]+1);
            count[msg.sender]++;
        }
    }

    function time() public view returns (uint)
    {
        return block.timestamp;
    }

    function soldTime(address seller) public view returns(uint)
    {
        return lastSold[seller];
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
