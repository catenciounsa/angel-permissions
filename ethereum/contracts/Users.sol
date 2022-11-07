// SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.9;
 
contract UserPermission  {
    address[] public users;
    mapping(address => bool) createdUsers;
 
    function createUser(string memory name, 
                        string memory email,
                        uint birthday, //format yyyymmdd
                        uint weight,
                        uint height) public {
        require(!createdUsers[msg.sender]); // Verify if the user was not created yet
        address newUser = new User(name, email, birthday, weight, height, msg.sender);
        users.push(newUser);
    }
 
    function getUsers() public view returns (address[] memory) {
        return users;
    }
}

contract Permission {
    // owner 
    string description;
    uint minimum;
    address manager;
    
    // other
    mapping(address => bool) thirdParties;
    uint thirdPartiesCounter;
    bool approved;

    constructor (
        string memory description_,
        uint minimum_,
        address manager_
    ) {
        description = description_;
        minimum = minimum_;
        manager = manager_;
        thirdPartiesCounter = 0;
        approved = false;
    }

    function contribute() public payable{
        require(msg.value > minimum);

        thirdPartiesCounter++;
    }
}

contract User {
    // owner
    string public name;
    string public email;
    uint public birthday;
    uint public weight;
    uint public height;
    address public manager;

    // other
    address payable[] public permissions;

    // This is to let, only the user to have control over the data
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    constructor (   string memory name_, 
                    string memory email_,
                    uint birthday_,
                    uint weight_, 
                    uint height_,
                    address manager_) {
        name = name_;
        email = email_;
        birthday = birthday_;
        weight = weight_;
        height = height_;
        manager = manager_;
    }
 
    function registerPermission(string memory description, uint minimum) public restricted {
        address newPermission = address( new Permission(description, minimum, msg.sender) );
        permissions.push( payable(newPermission) );
    }

    function approvePermission(uint index) public restricted{
        Permission storage permission = new Permissions(permissions[index]);

        permission.approved = true;
    }

    function getSummary() public view returns (
        uint, uint, address
    ) {
        return (
            address(this).balance,
            permissions.length,
            manager
        );
    }

    function getPermissions() public view returns (address[] memory) {
        return permissions;
    }
}   