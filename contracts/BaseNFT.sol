// SPDX-License-Identifier: LICENSE
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTMarketplace is ERC721URIStorage, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address payable owner;
    uint256 private maxSupply = 100_000;
    string private contractMetadata;

    modifier onlyOwner() {
        require(owner == msg.sender, "Only Contract Owner can access this");
        _;
    }

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        owner = payable(msg.sender);
    }

    function getNftName() external view returns (string memory) {
        return name();
    }

    function getNftSymbol() external view returns (string memory) {
        return symbol();
    }

    function getMetadata(
        uint256 tokenId
    ) external view returns (string memory) {
        return tokenURI(tokenId);
    }

    /** to retrieve contract-level metadata (this will be accessed by OpenSea) */
    function getContractURI() public view returns (string memory) {
        return contractMetadata;
    }

    /** Sets contract-level metadata */
    function setContractURI(string memory metadataURI) external onlyOwner {
        contractMetadata = metadataURI;
    }

    function getMaxSupply() external view returns (uint256) {
        return maxSupply;
    }

    /** To update max supply on demand */
    function updateMaxSupply(uint256 _maxSupply) public onlyOwner {
        maxSupply = _maxSupply;
    }

    /** Mints a token */
    function mintToken(
        string memory tokenURI
    ) external onlyOwner returns (uint) {
        uint256 currentTokenId = _tokenIds.current();
        require(currentTokenId < maxSupply, "Marketplace max supply reached");

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        return newTokenId;
    }

    /** Burns a token */
    function burnToken(uint256 tokenId) external onlyOwner {
        // require(_ownerOf(tokenId) == msg.sender, 'Only item owner can perform this operation');
        _burn(tokenId);
    }

    /** Transfers token from one adress to other */
    function transfer(
        address from,
        address to,
        uint256 tokenId
    ) external onlyOwner {
        _transfer(from, to, tokenId);
    }
}
