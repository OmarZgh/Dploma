/**
 * @type import('hardhat/config').HardhatUserConfig
 */

import { config as dotEnvConfig } from "dotenv";
dotEnvConfig({ path: "./.env"});

require("@nomiclabs/hardhat-ethers");
// const API_URL  = "https://eth-sepolia.g.alchemy.com/v2/P6zmb6lMhjRLlQKIgIFcSZ8zuG-Q2Sq0"
const PRIVATE_KEY  = process.env.PRIVATE_KEY
const API_URL=process.env.API_URL;
module.exports = {
  solidity: "0.8.3",
  defaultNetwork: "sepolia",
  networks: {
    sepolia: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
      chainId: 11155111
    }
  },
}
