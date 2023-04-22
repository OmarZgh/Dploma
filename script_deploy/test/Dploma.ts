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

        // redifining the object
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
                temp_title: 'New title',
                temp_name: 'New name',
                temp_date: 'New date',
                temp_spec: []

            }
        }

        const certification = await dploma.modifyTemplate("0xBD5BB9BC75B79A19D99106DBF88F3F2ECE22D3FC164E4A67C94FB6F6BA4D88A1", data.template.temp_title, data.template.temp_name, data.template.temp_date, data.template.temp_spec)
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
            addcertfier: "0x0000000000000000000000000000000000000000",
            certified: {},
            certifier: {},
            template: {},
        }

        await dploma.connect(data.addcertfier).deleteCertifiication("0xBD5BB9BC75B79A19D99106DBF88F3F2ECE22D3FC164E4A67C94FB6F6BA4D88A1")
        const certificationPostDeletion = await dploma.getCertification("0xBD5BB9BC75B79A19D99106DBF88F3F2ECE22D3FC164E4A67C94FB6F6BA4D88A1")
        const template = (certificationPostDeletion[4].splice(3))
        expect(template).to.equal(data.template)
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
            certified: {
                cfiedFirstname: 'hidden',
                cfiedLastname: 'hidden',
                cfiedBirthdate: 'hidden',
            },
            certifier: {},
            template: {
                temp_title: '',
                temp_name: '',
                temp_date: '',
                temp_spec: []

            }
        }

        //TODO add parameters with
        const certification = await dploma.connect(data.addcertfied).toggleStudentVisibility()
        const certificationPostDeletion = await dploma.toogleStudentVisbility("0xBD5BB9BC75B79A19D99106DBF88F3F2ECE22D3FC164E4A67C94FB6F6BA4D88A1")
        const certified= (certificationPostDeletion[2])
        expect(certified).to.equal(data.certified)

    });
});
