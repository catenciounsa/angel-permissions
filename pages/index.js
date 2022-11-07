import React, { Component, createFactory } from "react";
import UserPermission from "../ethereum/userpermission";

class UserPermissionIndex extends Component {
    static async getInitialProps() {
        const permissions = await userPermissions.method.getUsers().call();
        
        return {permissions};
    }
}