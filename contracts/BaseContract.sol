// SPDX-License-Identifier: LICENSE
pragma solidity ^0.8.20;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

enum ChallengeVisibility {
    Public,
    Private
}
enum ChallengeStatus {
    Ongoing,
    Completed
}

struct NftInfo {
    uint256 id;
    string metadata;
}
struct Participant {
    address participant; // participant address. (address is keyword, using participant instead.)
    uint daysCompleted; // days completed for that participant in the challenge
}
struct Challenge {
    uint challengeId; // unique identifier for challenge
    string challengeName; // name of the challenge
    uint startDate; // start date of the challenge
    uint endDate; // endDate of the challenge
    uint totalDays;
    uint stakedAmount; // to have a definite value of the amount that a person can stake to participate in this challenge
    uint participantsLimit; // number of participants that can join the challenge
    uint goal; // goal steps needed to complete for each day
    address creator; // address of the challenge creator
    string passkey; // passkey required to join the challenge if it's private, passkey shouldn't be null when creating a private challenge
    Participant[] participants; // list of participants for the challenge
    ChallengeVisibility visibility; // Indicates whether the challenge is public or private
    ChallengeStatus status; // challenge status
    mapping(address => uint) participantIndex; // Maps participant's address to their index in participants array
}

struct RespChallenge {
    uint challengeId; // unique identifier for challenge
    string challengeName; // name of the challenge
    uint startDate; // start date of the challenge
    uint endDate; // endDate of the challenge
    uint totalDays;
    uint stakedAmount; // to have a definite value of the amount that a person can stake to participate in this challenge
    uint participantsLimit; // number of participants that can join the challenge
    uint goal; // goal steps needed to complete for each day
    address creator; // address of the challenge creator
    uint status;
    uint visibility;
    uint participantsCount;
}

contract BaseContract is ERC721URIStorage, ReentrancyGuard, ERC721Enumerable {
    using Strings for uint256;

    uint256 private _tokenIds;
    address payable owner;
    uint256 private maxSupply = 10_000;

    // Mapping to store challenges by challenge ID
    mapping(uint => Challenge) private challenges;
    uint public numChallenges;

    // Mapping to store challenges by status
    mapping(ChallengeStatus => uint[]) private challengesByStatus;

    // Mapping to store challenges joined by each user
    mapping(address => uint[]) private userChallenges;

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

    /** Returns the NftInfo based on tokens owned by the given address */
    function getOwnedTokens(address _owner) external view returns (NftInfo[] memory) {
        uint256 balance = balanceOf(_owner);
        NftInfo[] memory tokens = new NftInfo[](balance);
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = super.tokenOfOwnerByIndex(_owner, i);
            tokens[i] = NftInfo(tokenId, tokenURI(tokenId));
        }
        return tokens;
    }

    // Function to get challenges joined by a user
    function getUserChallenges(address _user) external view returns (RespChallenge[] memory) {
        uint256 userChallengesCount = userChallenges[_user].length;

        RespChallenge[] memory challengesInfo = new RespChallenge[](userChallengesCount);
        uint index = 0;
        for (uint i = 0; i < userChallengesCount; i++) {
            uint _challengeId = userChallenges[_user][i];
            challengesInfo[index].challengeId = challenges[_challengeId].challengeId;
            challengesInfo[index].challengeName = challenges[_challengeId].challengeName;
            challengesInfo[index].startDate = challenges[_challengeId].startDate;
            challengesInfo[index].endDate = challenges[_challengeId].endDate;
            challengesInfo[index].totalDays = challenges[_challengeId].totalDays;
            challengesInfo[index].stakedAmount = challenges[_challengeId].stakedAmount;
            challengesInfo[index].participantsLimit = challenges[_challengeId].participantsLimit;
            challengesInfo[index].goal = challenges[_challengeId].goal;
            challengesInfo[index].creator = challenges[_challengeId].creator;
            challengesInfo[index].status = uint256(challenges[_challengeId].status);
            challengesInfo[index].visibility = uint256(challenges[_challengeId].visibility);
            challengesInfo[index].participantsCount = challenges[_challengeId].participants.length;
            index++;
        }

        return challengesInfo;
    }

    function getParticipants(uint _challengeId) external view returns (Participant[] memory) {
        return challenges[_challengeId].participants;
    }

    // Function to get list of all public challenges that are open
    function publicChallenges() external view returns (RespChallenge[] memory) {
        uint publicChallengesCount = 0;
        for (uint i = 0; i < numChallenges; i++) {
            if (challenges[i].visibility == ChallengeVisibility.Public) {
                publicChallengesCount++;
            }
        }

        RespChallenge[] memory challengesInfo = new RespChallenge[](publicChallengesCount);
        uint index = 0;
        for (uint i = 0; i < numChallenges; i++) {
            if (challenges[i].visibility == ChallengeVisibility.Public) {
                challengesInfo[index].challengeId = challenges[i].challengeId;
                challengesInfo[index].challengeName = challenges[i].challengeName;
                challengesInfo[index].startDate = challenges[i].startDate;
                challengesInfo[index].endDate = challenges[i].endDate;
                challengesInfo[index].totalDays = challenges[i].totalDays;
                challengesInfo[index].stakedAmount = challenges[i].stakedAmount;
                challengesInfo[index].participantsLimit = challenges[i].participantsLimit;
                challengesInfo[index].goal = challenges[i].goal;
                challengesInfo[index].creator = challenges[i].creator;
                challengesInfo[index].status = uint256(challenges[i].status);
                challengesInfo[index].visibility = uint256(challenges[i].visibility);
                challengesInfo[index].participantsCount = challenges[i].participants.length;
                index++;
            }
        }

        return challengesInfo;
    }

    // Function to join a private challenge by providing passkey
    function joinPrivateChallenge(uint _challengeId, string memory _passKey) external payable {
        require(challenges[_challengeId].visibility == ChallengeVisibility.Private, 'Challenge is not private');
        require(keccak256(bytes(challenges[_challengeId].passkey)) == keccak256(bytes(_passKey)), 'Invalid passkey');
        require(msg.value == challenges[_challengeId].stakedAmount, 'Incorrect staked amount');
        require(challenges[_challengeId].participants.length < challenges[_challengeId].participantsLimit, 'Challenge is already full');

        for (uint i = 0; i < challenges[_challengeId].participants.length; i++) {
            require((challenges[_challengeId].participants[i].participant != msg.sender), 'User is already a participant');
        }

        // Add participant to the challenge
        Participant memory newParticipant = Participant({participant: msg.sender, daysCompleted: 0});
        challenges[_challengeId].participants.push(newParticipant);

        challenges[_challengeId].participantIndex[msg.sender] = challenges[_challengeId].participants.length - 1;

        // Add challenge to the user's joined challenges
        userChallenges[msg.sender].push(_challengeId);
    }

    // Function to join a public challenge
    function joinPublicChallenge(uint _challengeId) external payable {
        require(challenges[_challengeId].visibility == ChallengeVisibility.Public, 'Challenge is not public');
        require(msg.value == challenges[_challengeId].stakedAmount, 'Incorrect staked amount');
        require(challenges[_challengeId].participants.length < challenges[_challengeId].participantsLimit, 'Challenge is already full');

        // Check if user is already a participant in the challenge
        for (uint i = 0; i < challenges[_challengeId].participants.length; i++) {
            require((challenges[_challengeId].participants[i].participant != msg.sender), 'User is already a participant');
        }

        // Add participant to the challenge
        Participant memory newParticipant = Participant({participant: msg.sender, daysCompleted: 0});
        challenges[_challengeId].participants.push(newParticipant);

        challenges[_challengeId].participantIndex[msg.sender] = challenges[_challengeId].participants.length - 1;

        // Add challenge to the user's joined challenges
        userChallenges[msg.sender].push(_challengeId);
    }

    // Function to create a new challenge
    function createChallenge(
        string memory _challengeName,
        uint _startDate,
        uint _endDate,
        uint _totalDays,
        uint _stakedAmount,
        uint _participantsLimit,
        uint _goal,
        ChallengeVisibility _visibility,
        string memory _passkey
    ) external payable {
        require(msg.value == _stakedAmount, 'Incorrect staked amount');
        require(_participantsLimit > 2, 'Minimum 2 participants should be allowed to join the challenge');
        if (_visibility == ChallengeVisibility.Private) {
            require(!Strings.equal(_passkey, ''), "passkey can't be empty for private challenge");
        }

        uint _challengeId = numChallenges++;

        Challenge storage ch = challenges[_challengeId];
        ch.challengeId = _challengeId;
        ch.challengeName = _challengeName;
        ch.startDate = _startDate;
        ch.endDate = _endDate;
        ch.totalDays = _totalDays;
        ch.stakedAmount = _stakedAmount;
        ch.participantsLimit = _participantsLimit;
        ch.visibility = _visibility;
        ch.passkey = _visibility == ChallengeVisibility.Private ? _passkey : ''; // public challenges don't need passkey to join
        ch.goal = _goal;
        ch.status = ChallengeStatus.Ongoing;

        ch.participants.push(Participant({participant: msg.sender, daysCompleted: 0}));
        challenges[_challengeId].participantIndex[msg.sender] = challenges[_challengeId].participants.length - 1;
        userChallenges[msg.sender].push(_challengeId);

        challengesByStatus[ChallengeStatus.Ongoing].push(_challengeId);
    }

    function dailyCheckIn(uint _challengeId, uint _stepCount) external onlyOwner {
        // get participant data
        uint participantIdx = challenges[_challengeId].participantIndex[msg.sender];
        Participant storage participant = challenges[_challengeId].participants[participantIdx];

        require(participant.participant != address(0), 'Participant not found in challenge');
        require(challenges[_challengeId].status == ChallengeStatus.Ongoing, 'Challenge is already completed');

        // increment daysCompleted based on the stepcount
        participant.daysCompleted += _stepCount >= challenges[_challengeId].goal ? 1 : 0;
    }

    function decideWinner(uint _challengeId) external onlyOwner {
        Challenge storage challenge = challenges[_challengeId];
        require(challenge.status == ChallengeStatus.Ongoing, 'Challenge is already completed');

        uint maxDaysCompleted = 0;
        address winner;

        for (uint i = 0; i < challenge.participantsLimit; i++) {
            Participant memory participant = challenge.participants[i];
            if (participant.daysCompleted > maxDaysCompleted) {
                maxDaysCompleted = participant.daysCompleted;
                winner = participant.participant;
            }
        }

        // TODO: change logic such that there can be multiple winners
        // ex: suppose two participants in a challenge and both completed the challenge with a count of 2 days, both should be rewarded equally.

        require(winner != address(0), 'No winner found');

        payable(winner).transfer(challenge.stakedAmount);

        challenge.status = ChallengeStatus.Completed;
        removeFromOngoingChallengesList(_challengeId);
        challengesByStatus[ChallengeStatus.Completed].push(_challengeId);
    }

    function removeFromOngoingChallengesList(uint value) internal {
        uint index = findOngoingChallengesIndex(value);
        require(index < challengesByStatus[ChallengeStatus.Ongoing].length, 'Value not found in array');

        for (uint i = index; i < challengesByStatus[ChallengeStatus.Ongoing].length - 1; i++) {
            challengesByStatus[ChallengeStatus.Ongoing][i] = challengesByStatus[ChallengeStatus.Ongoing][i + 1];
        }

        challengesByStatus[ChallengeStatus.Ongoing].pop();
    }

    function findOngoingChallengesIndex(uint value) internal view returns (uint) {
        for (uint i = 0; i < challengesByStatus[ChallengeStatus.Ongoing].length; i++) {
            if (challengesByStatus[ChallengeStatus.Ongoing][i] == value) {
                return i;
            }
        }
        return challengesByStatus[ChallengeStatus.Ongoing].length;
    }

    function uint256ToString(uint256 value) public pure returns (string memory) {
        return value.toString();
    }

    // gas expensive, use only in view/pure functions :)
    function concatenateStrings(string memory a, string memory b) public pure returns (string memory) {
        return string(abi.encodePacked(a, b));
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
