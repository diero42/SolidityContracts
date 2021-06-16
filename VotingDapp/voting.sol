pragma solidity ^0.4.19;

import "./ownable.sol";

/// @title Voting Dapp
/// @author diero42
/// @notice This contract can be used to initiate an election, nominate candidates, and vote.
contract Voting is Ownable {

  mapping (address => bool) hasVoted;
  mapping (address => bool) isCandidate;
  mapping (address => uint) candIndex;
  
  struct Candidate {
    address candId;
    string name;
    uint votes;
  }
  
  Candidate[] public candidates;
  
  /// @notice Public function to nominate any candidate using their address.
  /// @dev Tests if candidate has already been nominated before proceeding.
  /// @param candAddress Address of the nominee.
  /// @param candName Real name of the nominee.
  function nominateCandidate(address candAddress, string candName) public {
    require(isCandidate[candAddress] == false);
    candIndex[candAddress] = candidates.push(Candidate(candAddress,candName,0)) - 1;
    isCandidate[candAddress] = true;
  }
  
  /// @notice Voting function. Each address can vote once for an existing candidate.
  /// @param cand Address of existing candidate.
  function vote(address cand) public {
    require(hasVoted[msg.sender] == false);
    require(isCandidate[cand] == true);
    candidates[candIndex[cand]].votes++;
  }
}
