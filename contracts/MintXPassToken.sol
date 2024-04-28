// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MintXPassToken is ERC721Enumerable, Ownable {
    uint constant public MAX_TOKEN_COUNT = 1000;

    string baseURI;
    string notRevealedUri;
    bool public revealed = false;
    bool public publicMintEnabled = false;

    function _baseURI() override internal view returns (string memory) {
      return baseURI;
    }

    function _notrevealedURI() internal view returns (string memory) {
      return notRevealedUri;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
      baseURI = _newBaseURI;
    }

    function setNotRevealedURI(string memory _newNotRevealedURI) public onlyOwner {
      notRevealedUri = _newNotRevealedURI;
    }

    function reveal(bool _state) public onlyOwner{
      revealed = _state;
    }

    string public metadataURI;

    // 10^18 Peb = 1 Klay
    uint public xPassTokenPrice = 1000000000000000000;

    constructor (string memory _name, string memory _symbol, string memory _metadataURI) Ownable(msg.sender) ERC721(_name, _symbol) {
        metadataURI = _metadataURI;
    }

    function tokenURI(uint _tokenId) override public view returns (string memory) {

        return string(abi.encodePacked(metadataURI, '/', Strings.toString(_tokenId), ".json"));
  }

  function mintXPassToken() public payable {
    require(xPassTokenPrice <= msg.value, "Not enough Klay.");
    require(MAX_TOKEN_COUNT > totalSupply(), "No more minting is possible.");

    uint tokenId = totalSupply() + 1;

    payable(owner()).transfer(msg.value);

    _mint(msg.sender, tokenId);
  }

  function safeMint(address to) public onlyOwner {
        //uint256 tokenId = _tokenIdCounter.current();
        //_tokenIdCounter.increment();
        require(MAX_TOKEN_COUNT > totalSupply(), "No more minting is possible.");
        uint tokenId = totalSupply() + 1;
        
        _safeMint(to, tokenId);
  }

  function batchMint(address to, uint amount) public onlyOwner{
        for (uint i = 0; i < amount; i++) {
            safeMint(to);
        }
  }

}