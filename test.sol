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

}
