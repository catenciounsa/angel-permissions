// SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.9;

contract UserPermission {
    struct User {
        bytes32 name;
        bytes32 email;
        uint weight;
        uint height;
        uint birthday;
    }

    struct Permission {
        address user;
        string description;
        uint minimum;
    }
    
    User[] public users;
    Permission[] public permissions;
    mapping(address => Permission) mapPermissions;

    function createUser(
        bytes32 _name,
        bytes32 _email,
        uint _weight,
        uint _height,
        uint _birthday) public{
        users.push( User({
            name : _name,
            email : _email,
            weight : _weight,
            height : _height,
            birthday : _birthday
        }));    
    }

    function createPermission( string memory description, uint minimum ) public {
        permissions.push( Permission({
            user : msg.sender,
            description : description,
            minimum : minimum
        }));
    }

    function contribute(uint index) public payable {
        Permission storage permission = permissions[index];
        require(msg.value > permission.minimum);
    }

}