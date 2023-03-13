/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require("@nomiclabs/hardhat-ethers");
const API_URL :string = "https://eth-goerli.g.alchemy.com/v2/GoPk5qRGiHAo9EUXOvUquXJFW-MsRg5i"
const PRIVATE_KEY :string = "PRIVATE KEY"

module.exports = {
  solidity: "0.8.3",
  defaultNetwork: "goerli",
  networks: {
    goerli: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
      chainId: 5
    }
  },
}