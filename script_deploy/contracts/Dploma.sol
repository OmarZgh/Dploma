// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Dploma {
    struct Certification {
        address certAddrCertifier;
        address certAddrCertified;
        Certified certCertified;
        Certifier certCertifier;
        Template certTemplate;
    }

    struct Template {
        string tempTitle;
        string tempName;
        uint256 tempDate; // Stocker la date sous forme de timestamp Unix
        string[] tempSpecs;
    }

    struct Certified {
        string cfiedFirstname;
        string cfiedLastname;
        string cfiedBirthdate;
    }

    struct Certifier {
        string cfierName;
        string cfierPhysicalAddress;
    }

    mapping(bytes32 => Certification) private mapCert;
    mapping(bytes32 => Template) private mapTemp;
    mapping(bytes32 => Certified) private unvisibleCertified;
    mapping(bytes32 => bool) private studentVisibility;
    uint256 private templateId = 0;

    event evtTemplate(string, bytes32);
    event evtCertifCreation(string, bytes32);
    event evtModificationMsg(string);
    event evtCertifiedVisibility(string);
    event evtDeletedCertif(string);

    function createHashOwner(address addrS) private view returns (bytes32) {
        return keccak256(abi.encode(msg.sender, addrS, block.timestamp));
    }

    function createTemplate(
        string memory _tempTitle,
        string memory _tempName,
        uint256 _tempDate,
        string[] memory _tempSpecs
    ) public returns (bytes32) {
        templateId += 1;
        bytes32 _hashTemplate = keccak256(abi.encode(templateId));

        mapTemp[_hashTemplate] = Template(_tempTitle, _tempName, _tempDate, _tempSpecs);

        emit evtTemplate("Template access key", _hashTemplate);
        return _hashTemplate;
    }

    function getTemplate(bytes32 _hashTemplate)
    private
    view
    returns (Template memory)
    {
        return mapTemp[_hashTemplate];
    }

    function insertWithTemplate(
        string memory _cfiedFirstname,
        string memory _cfiedLastname,
        string memory _cfiedBirthdate,
        string memory _cfierName,
        string memory _cfierAdress,
        bytes32 _hashTemplate,
        address _certifiedPubAddress
    ) public returns (bytes32) {
        bytes32 _idCert = createHashOwner(_certifiedPubAddress);
        Template memory _temp = getTemplate(_hashTemplate);
        mapCert[_idCert] = Certification(
            msg.sender,
            _certifiedPubAddress,
            Certified(_cfiedFirstname, _cfiedLastname, _cfiedBirthdate),
            Certifier(_cfierName, _cfierAdress),
            _temp
        );
        studentVisibility[_idCert] = true;
        emit evtCertifCreation("Certification access key", _idCert);
        return _idCert;
    }

    function insertWithoutTemplate(
        string memory _cfiedFirstname,
        string memory _cfiedLastname,
        string memory _cfiedBirthdate,
        string memory _cfierName,
        string memory _cfierPhysicalAddress,
        address _certifiedPubAddress,
        string memory _tempTitle,
        string memory _tempName,
        uint256 _tempDate,
        string[] memory _tempSpecs
    ) public returns (bytes32) {
        bytes32 _idCert = createHashOwner(_certifiedPubAddress);
        // Data insertion
        mapCert[_idCert] = Certification(
            msg.sender,
            _certifiedPubAddress,
            Certified(_cfiedFirstname, _cfiedLastname, _cfiedBirthdate),
            Certifier(_cfierName, _cfierPhysicalAddress),
            Template(_tempTitle, _tempName, _tempDate, _tempSpecs)
        );
        studentVisibility[_idCert] = true;
        emit evtCertifCreation("Certification access key", _idCert);
        return _idCert;
    }

    Certified private unknownCertified = Certified("hidden", "hidden", "hidden");

    function toggleStudentVisibility(bytes32 _hashCert) public {
        require(mapCert[_hashCert].certAddrCertifier == msg.sender);
        studentVisibility[_hashCert] = !studentVisibility[_hashCert];
        emit evtCertifiedVisibility("Certified public visibility has changed");
    }

    function getCertification(bytes32 _hashCert)
    public
    view
    returns (Certification memory)
    {
        Certification memory _cert = mapCert[_hashCert];
        if (!studentVisibility[_hashCert]) {
            _cert.certCertified = unknownCertified;
        }
        return _cert;
    }

    function setTemplateTitle(bytes32 _hashCert, string memory _title) private {
        Certification storage _cert = mapCert[_hashCert];
        _cert.certTemplate.tempTitle = _title;
    }

    function setTemplateName(bytes32 _hashCert, string memory _name) private {
        Certification storage _cert = mapCert[_hashCert];
        _cert.certTemplate.tempName = _name;
    }

    function setTemplateDate(bytes32 _hashCert, uint256 _tempDate) private {
        Certification storage _cert = mapCert[_hashCert];
        _cert.certTemplate.tempDate = _tempDate;
    }

    function setTemplateSpecs(bytes32 _hashCert, string[] memory _specs) private {
        Certification storage _cert = mapCert[_hashCert];
        _cert.certTemplate.tempSpecs = _specs;
    }

    function modifyTemplate(
        bytes32 _hashCert,
        string memory _tempTitle,
        string memory _tempName,
        uint256 _tempDate,
        string[] memory _tempSpecs
    ) public {
        require(mapCert[_hashCert].certAddrCertifier == msg.sender);
        setTemplateTitle(_hashCert, _tempTitle);
        setTemplateName(_hashCert, _tempName);
        setTemplateDate(_hashCert, _tempDate);
        setTemplateSpecs(_hashCert, _tempSpecs);

        emit evtModificationMsg("Certification data has been modified");
    }

    function deleteCertif(bytes32 _hashCert) public {
        require(mapCert[_hashCert].certAddrCertifier == msg.sender);
        delete mapCert[_hashCert];
    }
}