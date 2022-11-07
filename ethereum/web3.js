import Web3 from "web3";
/*
window.ethereum.request({ method: "eth_requestAccounts" });

const web3 = new Web3(window.ethereum);
*/
let web3;

if( typeof window !== "undefined" && typeof window.ethereum !== "undefined" ) {
    // We are in the browaser and metamask is running
    //window.ethereum.request({metod: "eth_requestAccounts"});
    //web3 = new Web3(window.ethereum);
    
    //web3 = new Web3(window.web3.currentProvider);
    web3 = new Web3(window.ethereum);
} else {
    // We are on the browser *OR* the user is not running metamask
    console.log("METAMASK");
    const provider = new Web3.providers.HttpProvider(
        "https://goerli.infura.io/v3/eaf9617414c34ae38b29b7bf31c0ba30"
        //"https://rinkeby.infura.io/v3/15c1d32581894b88a92d8d9e519e476c"
    );
    web3 = new Web3(provider);
}

export default web3;
