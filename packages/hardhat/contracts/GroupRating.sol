// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { IEAS, AttestationRequest, AttestationRequestData } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import { NO_EXPIRATION_TIME, EMPTY_UID, Attestation } from "@ethereum-attestation-service/eas-contracts/contracts/Common.sol";
import { ISchemaRegistry, SchemaRecord } from "@ethereum-attestation-service/eas-contracts/contracts/ISchemaRegistry.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract GroupRating is Ownable {
    error InvalidEAS();
    error NotWhitelisted();
    error AlreadyWhitelisted();
    error NotEnoughBalance();
    error TeamNotExists();
    error OnlyTeamMember();

    struct Team {
        mapping(address => bool) members;
        address[] memberList;
    }

    mapping(uint256 => Team) private teams;
    uint256[] private teamIds;
    uint256 private teamCounter;

    mapping(address => uint256[]) private addressToTeams;
    mapping(address => mapping(uint256 => uint)) public userCounter;

    IEAS private _eas = IEAS(0xaEF4103A04090071165F78D45D83A0C0782c2B2a);
    ISchemaRegistry private _schemaregistry = ISchemaRegistry(0x55D26f9ae0203EF95494AE4C170eD35f4Cf77797);
    bytes32 public schemaID;

    constructor(address _owner, bytes32 _schemaID) {
        transferOwnership(_owner); // Set the owner using Ownable's transferOwnership function
        schemaID = _schemaID;
    }

    modifier onlyTeamMember(uint256 teamId) {
        if (!teams[teamId].members[msg.sender]) {
            revert OnlyTeamMember();
        }
        _;
    }

    function createTeam(address[] memory _whitelist) external onlyOwner returns (uint256) {
        teamCounter++;
        uint256 newTeamId = teamCounter;
        teamIds.push(newTeamId); // Add new team ID to the list
        for (uint i = 0; i < _whitelist.length; i++) {
            address member = _whitelist[i];
            teams[newTeamId].members[member] = true;
            teams[newTeamId].memberList.push(member);
            addressToTeams[member].push(newTeamId);
        }
        return newTeamId; // Return the new team ID
    }

    function addMember(uint256 teamId, address _address) external onlyOwner {
        if (!teams[teamId].members[_address]) {
            teams[teamId].members[_address] = true;
            teams[teamId].memberList.push(_address);
            addressToTeams[_address].push(teamId);
        } else {
            revert AlreadyWhitelisted();
        }
    }

    function getTeamsByAddress(address _address) external view returns (uint256[] memory) {
        return addressToTeams[_address];
    }

    function getTotalTeams() external view returns (uint256[] memory) {
        return teamIds;
    }

    function assignRate(uint256 teamId, address _recipient, uint8 rateAmount) external returns (bytes32) {
        require(teams[teamId].members[_recipient], "Recipient must be a team member");

        userCounter[_recipient][teamId] += rateAmount;

        bytes memory _data = abi.encode(teamId, _recipient, userCounter[_recipient][teamId]);
        
        try _eas.attest(
            AttestationRequest({
                schema: schemaID,
                data: AttestationRequestData({
                    recipient: _recipient,
                    expirationTime: NO_EXPIRATION_TIME, // No expiration time
                    revocable: true,
                    refUID: EMPTY_UID, // No references UI
                    data: _data,
                    value: 0 // No value/ETH
                })
            })
        ) returns (bytes32 attestationId) {
            return attestationId;
        } catch Error(string memory reason) {
            revert(reason);
        } catch (bytes memory) {
            revert("Attestation failed unexpectedly");
        }
    }

    function distributeGrant(uint256 teamId, uint256 totalGrant) external onlyOwner {
        require(teamId <= teamCounter, "Team does not exist");

        uint256 totalPoints = 0;
        address[] memory members = teams[teamId].memberList;

        for (uint i = 0; i < members.length; i++) {
            totalPoints += userCounter[members[i]][teamId];
        }

        require(totalPoints > 0, "No points to distribute");

        for (uint i = 0; i < members.length; i++) {
            address member = members[i];
            uint256 memberShare = (userCounter[member][teamId] * totalGrant) / totalPoints;
            (bool success, ) = member.call{value: memberShare}("");
            require(success, "Transfer failed");
        }
    }

    receive() external payable {}
}
