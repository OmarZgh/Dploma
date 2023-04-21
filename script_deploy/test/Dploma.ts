import {time, loadFixture} from "@nomicfoundation/hardhat-network-helpers";
import {anyValue} from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import {expect} from "chai";
import {ethers} from "hardhat";

describe("Dploma", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.

  it("Should evaluate the data integrity while fetching a certification", async function () {
    const [signer] = await ethers.getSigners();
    const Dploma = await ethers.getContractFactory("Dploma");
    const dploma = await Dploma.deploy();
    await dploma.deployed();

    const data = {
      addcertfied: "0x0000000000000000000000000000000000000000",
      addcertfier: "0x00000000",
      certified: {},
      certifier: {},
      template: {
        temp_title: '',
        temp_name: '',
        temp_date: '',
        temp_spec: []

      }
    }

    const certification = await dploma.getCertification("0xBD5BB9BC75B79A19D99106DBF88F3F2ECE22D3FC164E4A67C94FB6F6BA4D88A1")
    const addcertfier = (certification[0])
    const addcertfied = (certification[1])
    const certified = (certification[2])
    const certifier = (certification[3])
    const template = (certification[4].splice(3))
    console.log(template)
    expect(template).to.equal(data.template)

  });

  it("Should check the modification functionality", async function () {
    const [signer] = await ethers.getSigners();
    const Dploma = await ethers.getContractFactory("Dploma");
    const dploma = await Dploma.deploy();
    await dploma.deployed();

    //modifed object
    const data = {
      addcertfied: "0x0000000000000000000000000000000000000000",
      addcertfier: "0x00000000",
      certified: {},
      certifier: {},
      template: {
        temp_title: '',
        temp_name: '',
        temp_date: '',
        temp_spec: []

      }
    }

    const certification = await dploma.getCertification("0xBD5BB9BC75B79A19D99106DBF88F3F2ECE22D3FC164E4A67C94FB6F6BA4D88A1")
    const addcertfier = (certification[0])
    const addcertfied = (certification[1])
    const certified = (certification[2])
    const certifier = (certification[3])
    const template = (certification[4].splice(3))

    expect(template).to.equal(data.template)
    //

  });
  it("Should check the deletion of a certification", async function () {
    const [signer] = await ethers.getSigners();
    const Dploma = await ethers.getContractFactory("Dploma");
    const dploma = await Dploma.deploy();
    await dploma.deployed();

    //modifed object
    const data = {
      addcertfied: "0x0000000000000000000000000000000000000000",
      addcertfier: "0x00000000",
      certified: {},
      certifier: {},
      template: {
        temp_title: '',
        temp_name: '',
        temp_date: '',
        temp_spec: []

      }
    }

    const certification = await dploma.getCertification("0xBD5BB9BC75B79A19D99106DBF88F3F2ECE22D3FC164E4A67C94FB6F6BA4D88A1")
    const addcertfier = (certification[0])
    const addcertfied = (certification[1])
    const certified = (certification[2])
    const certifier = (certification[3])

  });
  it("Should check the modification of the visibility of a certified actor", async function () {
    const [signer] = await ethers.getSigners();
    const Dploma = await ethers.getContractFactory("Dploma");
    const dploma = await Dploma.deploy();
    await dploma.deployed();

    //modifed object
    const data = {
      addcertfied: "0x0000000000000000000000000000000000000000",
      addcertfier: "0x00000000",
      certified: {},
      certifier: {},
      template: {
        temp_title: '',
        temp_name: '',
        temp_date: '',
        temp_spec: []

      }
    }

    //TODO add parameters with
    const certification = await dploma.toggleStudentVisibility()
    const certified = (certification[2])


    expect(certified).to.equal(data.certified)
  });
});
