// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Dploma {
    struct Certification {
        address certAddrCertifier;
        address certAddrCertified;
        Certified certCertified;
        Certifier certCedrtifier;
        Template certTemplate;
    }

    struct Template {
        string tempTitle;
        string tempName;
        string tempDate;
        string[] tempSpec;
    }

    struct Certified {
        string cfiedFirstname;
        string cfiedLastname;
        string cfiedBirthdate;
    }

    struct Certifier {
        string cfierName;
        string cfierPhysicalAdress;
    }

    mapping(bytes32 => Certification) private mapCert;
    mapping(bytes32 => Template) private mapTemp;
    mapping(bytes32 => Certified) private unvisibleCertified;
    mapping(bytes32 => bool) private studentVisibility;
    uint256 private templateId = 0;

    event evtTemplate(string, bytes32);
    event evtCertifCreation(string, bytes32);
    event evtModificationMsg(string);
    event evtCertifiedVisisbility(string);
    event evtDeletedCertif(string);

    function createhashOwner(address addrS) private view returns (bytes32) {
        return keccak256(abi.encode(msg.sender, addrS, block.timestamp));
    }

    function createTemplate(
        string memory tempTitle,
        string memory tempName,
        string memory tempDate,
        string[] memory tempSpecs
    ) public returns (bytes32) {
        templateId += 1;
        bytes32 hashTemplate = keccak256(abi.encode(templateId));
        mapTemp[hashTemplate] = Template(tempTitle, tempName, tempDate, tempSpecs);

        emit evtTemplate("Template access key", hashTemplate);
        return hashTemplate;
    }

    function getTemplate(bytes32 hashTemplate)
        private
        view
        returns (Template memory)
    {
        return mapTemp[hashTemplate];
    }

    function insertWithTemplate(
        string memory cfiedFirstname,
        string memory cfiedLastname,
        string memory cfiedBirthdate,
        string memory cfierName,
        string memory cfierAdress,
        bytes32 hashTemplate,
        address certifiedPubAdress
    ) public returns (bytes32) {
        bytes32 idCert = createhashOwner(certifiedPubAdress);
        Template memory temp = getTemplate(hashTemplate);
        mapCert[idCert] = Certification(
            msg.sender,
            certifiedPubAdress,
            Certified(cfiedFirstname, cfiedLastname, cfiedBirthdate),
            Certifier(cfierName, cfierAdress),
            temp
        );
        studentVisibility[idCert] = true;
        emit evtCertifCreation("Certification access key", idCert);
        return idCert;
    }

    function insertWithoutTemplate(
        string memory cfiedFirstname,
        string memory cfiedLastname,
        string memory cfiedBirthdate,
        string memory cfierName,
        string memory cfierPhysicalAdress,
        address certifiedPubAdress,
        string memory temptitle,
        string memory tempName,
        string memory tempDate,
        string[] memory tempSpecs
    ) public returns (bytes32) {
        bytes32 idCert = createhashOwner(certifiedPubAdress);

        //data insertion
        mapCert[idCert] = Certification(
            msg.sender,
            certifiedPubAdress,
            Certified(cfiedFirstname, cfiedLastname, cfiedBirthdate),
            Certifier(cfierName, cfierPhysicalAdress),
            Template(temptitle, tempName, tempDate, tempSpecs)
        );
        studentVisibility[idCert] = true;
        emit evtCertifCreation("Certification access key", idCert);
        return idCert;
    }

    Certified unknowCertifed = Certified("hidden", "hidden", "hidden");

    function toggleStudentVisibility(bytes32 hashCert) public {
        require(mapCert[hashCert].certAddrCertifier == msg.sender);
        studentVisibility[hashCert] = !studentVisibility[hashCert];
        emit evtCertifiedVisisbility("Certified public visbility has changed");
    }

    function getCertification(bytes32 hashCert)
        public
        view
        returns (Certification memory)
    {
        Certification memory cert = mapCert[hashCert];
        if (!studentVisibility[hashCert]) {
            cert.certCertified = unknowCertifed;
        }
        return cert;
    }

    function setTemplateTitle(bytes32 hashCert, string memory title) private {
        Certification storage cert = mapCert[hashCert];
        cert.certTemplate.tempTitle = title;
    }

    function setTemplateName(bytes32 hashCert, string memory name) private {
        Certification storage cert = mapCert[hashCert];
        cert.certTemplate.tempName = name;
    }

    function setTemplateDate(bytes32 hashCert, string memory date) private {
        Certification storage cert = mapCert[hashCert];
        cert.certTemplate.tempDate = date;
    }

    function setTemplateSpecs(bytes32 hashCert, string[] memory specs)
        private
    {
        Certification storage cert = mapCert[hashCert];
        cert.certTemplate.tempSpec = specs;
    }

    function ModifyTemplate(
        bytes32 hashCert,
        string memory tempTitle,
        string memory tempName,
        string memory tempDate,
        string[] memory tempSpecs
    ) public {
        require(mapCert[hashCert].certAddrCertifier == msg.sender);
        setTemplateTitle(hashCert, tempTitle);
        setTemplateName(hashCert, tempName);
        setTemplateDate(hashCert, tempDate);
        setTemplateSpecs(hashCert, tempSpecs);

        emit evtModificationMsg("Certification data has been modified");
    }

    function DeleteCertif(bytes32 hashCert) public {
        require(mapCert[hashCert].certAddrCertifier == msg.sender);
        delete mapCert[hashCert];
    }
}
