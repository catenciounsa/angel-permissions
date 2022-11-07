// SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.9;
 
contract UserFactory {
    address payable[] public deployedUsers;
 
    function createUser(
        string memory name,
        uint birthday,
        uint weight,
        uint height,
        uint minimum) public {
        address newUser = address(new User(name, birthday, weight, height, minimum, msg.sender));
        deployedUsers.push(payable(newUser));
    }
 
    function getDeployedUsers() public view returns (address payable[] memory) {
        return deployedUsers;
    }
}
 
contract User {
    struct Permission {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    string name;
    uint birthday;
    uint weight;
    uint height;
 
    Permission[] public permissions;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
 
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
 
    constructor (
        string memory _name,
        uint _birthday,
        uint _weight,
        uint _height,
        uint minimum, address creator) {
        name = _name;
        birthday = _birthday;
        weight = _weight;
        height = _height;
        manager = creator;
        minimumContribution = minimum;
    }
 
    function contribute() public payable {
        require(msg.value > minimumContribution);
 
        approvers[msg.sender] = true;
        approversCount++;
    }
 
    function createPermission(string memory description, uint value, address recipient) public restricted {
        Permission storage newPermission = permissions.push(); 
        newPermission.description = description;
        newPermission.value= value;
        newPermission.recipient= recipient;
        newPermission.complete= false;
        newPermission.approvalCount= 0;
    }
 
    function approvePermission(uint index) public {
        Permission storage permission = permissions[index];
 
        require(approvers[msg.sender]);
        require(!permission.approvals[msg.sender]);
 
        permission.approvals[msg.sender] = true;
        permission.approvalCount++;
    }
 
    function finalizePermission(uint index) public restricted {
        Permission storage permission = permissions[index];
 
        require(permission.approvalCount > (approversCount / 2));
        require(!permission.complete);
 
        payable(permission.recipient).transfer(permission.value);
        permission.complete = true;
    }
    
    function getSummary() public view returns (
      uint, uint, uint, uint, address
      ) {
        return (
          minimumContribution,
          address(this).balance,
          permissions.length,
          approversCount,
          manager
        );
    }
    
    function getPermissionsCount() public view returns (uint) {
        return permissions.length;
    }
}   