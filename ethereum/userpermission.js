import web3 from './web3';
import UserPermission from './build/UserPermission.json';

const instance = new web3.eth.Contract(
    UserPermission.abi,
    "0x152Bf9B59C087CBbFBdd45F9E5d4aDb8c3034baA"
  );

export default instance;
