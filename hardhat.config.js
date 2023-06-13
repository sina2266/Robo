require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
//require("hardhat-deploy");

const accounts = {
  mnemonic: process.env.MNEMONIC,
};

/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
  solidity: {
    compilers: [{ version: "0.8.12" }, { version: "0.6.6" }],
  },
  networks: {
    fantomtest: {
      url: "https://rpc.testnet.fantom.network",
      //      accounts,
      chainId: 4002,
      live: false,
      saveDeployments: true,
      gasMultiplier: 2,
    },
    fantom: {
      url: "https://rpcapi.fantom.network",
      //      accounts,
      chainId: 250,
      live: false,
      saveDeployments: true,
      gasMultiplier: 2,
    },
    hardhat: {
      chainId: 31337,
    },
    localhost: {
      chainId: 31337,
    },
    polygon: {
      url: "",
      //      accounts,
      saveDeployments: true,
      chainId: 137,
    },
  },
};
