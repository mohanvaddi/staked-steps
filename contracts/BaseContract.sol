// SPDX-License-Identifier: LICENSE
pragma solidity ^0.8.20;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

contract BaseContract is ERC721URIStorage, ReentrancyGuard {
    uint256 private _tokenIds;

    address payable owner;
    uint256 private maxSupply = 10_000;
    string private contractMetadata;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        owner = payable(msg.sender);
    }

    /** Mints a token */
    function mintToken(string memory tokenURI) external onlyOwner returns (uint) {
        uint256 currentTokenId = _tokenIds;
        require(currentTokenId < maxSupply, 'Marketplace max supply reached');

        uint256 newTokenId = _tokenIds++;

        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        return newTokenId;
    }

    /** Burns a token */
    function burnToken(uint256 tokenId) external {
        require(_ownerOf(tokenId) == msg.sender, 'Only item owner can perform this operation');
        _burn(tokenId);
    }

    /** Transfers token from one adress to other */
    function transfer(address from, address to, uint256 tokenId) external onlyOwner {
        _transfer(from, to, tokenId);
    }

    // function getTokensOwnedByUser(address _owner) external view returns (uint256[] memory) {
    //     uint256 balance = balanceOf(_owner);
    //     uint256[] memory ownedTokens = new uint256[](balance);

    //     for (uint256 i = 0; i < balance; i++) {
    //         ownedTokens[i] = tokenOfOwnerByIndex(_owner, i);
    //     }

    //     return ownedTokens;
    // }

    // function _transfer(address from, address to, uint256 tokenId) internal override {
    //     super._transfer(from, to, tokenId);

    //     uint256[] storage fromTokens = tokenOfOwnerByIndex[from];
    //     uint256[] storage toTokens = tokenOfOwnerByIndex[to];

    //     for (uint256 i = 0; i < fromTokens.length; i++) {
    //         if (fromTokens[i] == tokenId) {
    //             fromTokens[i] = fromTokens[fromTokens.length - 1];
    //             break;
    //         }
    //     }
    //     fromTokens.pop();

    //     indexByToken[tokenId] = toTokens.length;
    //     toTokens.push(tokenId);
    // }

    modifier onlyOwner() {
        require(owner == msg.sender, 'Only Contract Owner can access this');
        _;
    }

    function getTokenMetadata(uint256 tokenId) external view returns (string memory) {
        return tokenURI(tokenId);
    }

    function getMaxSupply() external view returns (uint256) {
        return maxSupply;
    }

    /** To update max supply on demand */
    function updateMaxSupply(uint256 _maxSupply) public onlyOwner {
        maxSupply = _maxSupply;
    }
}
