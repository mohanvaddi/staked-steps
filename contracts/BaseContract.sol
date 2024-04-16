// SPDX-License-Identifier: LICENSE
pragma solidity ^0.8.20;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

contract BaseContract is ERC721URIStorage, ReentrancyGuard, ERC721Enumerable {
    uint256 private _tokenIds;

    address payable owner;
    uint256 private maxSupply = 10_000;
    string private contractMetadata;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        owner = payable(msg.sender);
    }

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

    /** Mints a token */
    function mintToken(string memory _tokenURI) external onlyOwner returns (uint) {
        uint256 currentTokenId = _tokenIds;
        require(currentTokenId < maxSupply, 'Marketplace max supply reached');

        uint256 newTokenId = _tokenIds++;

        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        return newTokenId;
    }

    /** Burns a token */
    function burnToken(uint256 tokenId) external {
        require(_ownerOf(tokenId) == msg.sender, 'Only item owner can perform this operation');
        _burn(tokenId);
    }

    /** Transfers token from one adress to other */
    function transfer(address from, address to, uint256 tokenId) external onlyOwner {
        require(_ownerOf(tokenId) == msg.sender, 'Only item owner can perform this operation');
        _transfer(from, to, tokenId);
    }

    /** Returns the number of tokens owned by the given address */
    function getOwnedTokens(address _owner) external view returns (string[] memory) {
        uint256 balance = balanceOf(_owner);
        string[] memory tokens = new string[](balance);
        for (uint256 i = 0; i < balance; i++) {
            tokens[i] = tokenURI(super.tokenOfOwnerByIndex(_owner, i));
        }
        return tokens;
    }

    // function overrides

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _update(address to, uint256 tokenId, address auth) internal virtual override(ERC721, ERC721Enumerable) returns (address) {
        super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 amount) internal virtual override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, amount);
    }
}
