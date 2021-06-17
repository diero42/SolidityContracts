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
  bool registration = false;
  bool election = false;
  uint timer;
  
  /// @notice Public function to nominate any user during the registration period using their address.
  /// @dev Tests if user has already been nominated before proceeding.
  /// @param candAddress Address of the nominee.
  /// @param candName Real name of the nominee.
  function nominateCandidate(address nomAddress, string nomName) public {
    require(registration == true);
    require(isCandidate[nomAddress] == false);
    candIndex[nomAddress] = candidates.push(Candidate(nomAddress,nomName,0)) - 1;
    isCandidate[nomAddress] = true;
  }
  
  /// @notice Voting function. Each user can vote once for an existing candidate during the election period.
  /// @param cand Address of existing candidate.
  function vote(address cand) public {
    require(registration == true);
    require(hasVoted[msg.sender] == false);
    require(isCandidate[cand] == true);
    candidates[candIndex[cand]].votes++;
    hasVoted[msg.sender] == true;
  }
  
  /// @notice Begins registration period. During this time,
  /// users can nominate any user once using nominateCandidate().
  /// @dev Will only run if it is not currently an election or registration period.
  function beginRegistration() public onlyOwner {
    require(registration == false);
    require(election == false);
    registration = true;    
  }
  
  /// @notice Begins election period. During this time,
  /// users can vote for any candidate once using nominateCandidate().
  /// @dev Will only run if it is not currently an election or registration period.
  function beginVoting() public onlyOwner {
    require(registration == true);
    require(election == false);
    registration = false;
    election = true;
  }
  
  function endElection() public onlyOwner {
    require(registration == false);
    require(election == true);
    election = false;
  }
}
