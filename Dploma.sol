// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// This contract represents a "Dploma" system that allows for the creation, storage, and retrieval of certifications.
contract Dploma {
    // Struct to represent the data for a certification
    struct Certification {
        // Address of the certifier
        address dip_addr_certifier;
        // Address of the certified individual
        address dip_addr_certified;
        // Data about the certified individual
        Certified dip_certified;
        // Data about the certifier
        Certifier dip_cedrtifier;
        // Data about the template used for the certification
        Template dip_template;
    }

    // Struct to represent the data for a template
    struct Template {
        // Title of the template
        string temp_title;
        // Name of the template
        string temp_name;
        // Date of the template
        string temp_date;
        // Specifications of the template
        string[] temp_spec;
    }

    // Struct to represent the data for a certified individual
    struct Certified {
        // First name of the certified individual
        string cfied_firstname;
        // Last name of the certified individual
        string cfied_lastname;
        // Birth date of the certified individual
        string cfied_birthdate;
    }

    // Struct to represent the data for a certifier
    struct Certifier {
        // Name of the certifier
        string cfier_name;
        // Address of the certifier
        string cfier_adress;
    }

    // Mapping to store the data for each certification using the certification's ID as the key
    mapping(bytes32 => Certification) private map_cert;
    // Mapping to store the data for each template using the template's ID as the key
    mapping(bytes32 => Template) private map_temp;
    // Mapping to store data about the certified individuals
    mapping(bytes32 => Certified) private unvisibleCertified;
    // Mapping to store whether a certification should be visible or not
    mapping(bytes32 => bool) private studentVisibility;
    // Counter to keep track of the number of templates created
    uint256 templateId = 0;

    // Event to log the creation of a template
    event evtTemplate(bytes32);
    // Event to log the creation of a certification
    event certifCreation(bytes32);
    // Event to log a modification to a certification
    event modificationMsg(string);
    // Event to log a change in the visibility of a certification
    event evtVisisbility(string);
    // Event to log the deletion of a certification
    event deletedCertif(string);

    // Private function to generate a unique ID for a certification using the sender's address and the current block's timestamp
    function createhashOwner(address _addrS) private view returns (bytes32) {
        // Generate the ID using the keccak256 hash function
        return keccak256(abi.encode(msg.sender, _addrS, block.timestamp));
    }

    // Function to create a new template
    function createTemplate(
        string memory _title,
        string memory _name,
        string memory _date,
        string[] memory _specs
    ) public returns (bytes32) {
        // Increment the template counter
        templateId += 1;
        // Generate a unique ID for the template using the keccak256 hash function
        bytes32 hashTemplate = keccak256(abi.encode(templateId));
        // Store the template data in the map
        map_temp[hashTemplate] = Template(_title, _name, _date, _specs);

        // Log the creation of the template
        emit evtTemplate(hashTemplate);
        // Return the template's ID
        return hashTemplate;
    }

    // Function to retrieve a template using its ID
    function getTemplate(bytes32 _hashTemplate)
        public
        view
        returns (Template memory)
    {
        // Return the template data from the map
        return map_temp[_hashTemplate];
    }

    // Function to create a new certification using an existing template
    function insertWithTemplate(
        string memory _cfied_firstname,
        string memory _cfied_lastname,
        string memory _cfied_birthdate,
        string memory _cfier_name,
        string memory _cfier_adress,
        bytes32 _hashTemplate,
        address _certified_pub_adress
    ) public returns (bytes32) {
        // Generate a unique ID for the certification using the createhashOwner function
        bytes32 idCert = createhashOwner(_certified_pub_adress);
        // Retrieve the template data
        Template memory temp = getTemplate(_hashTemplate);
        // Store the certification data in the map
        map_cert[idCert] = Certification(
            msg.sender,
            _certified_pub_adress,
            Certified(_cfied_firstname, _cfied_lastname, _cfied_birthdate),
            Certifier(_cfier_name, _cfier_adress),
            temp
        );
        // Set the certification to be visible
        studentVisibility[idCert] = true;
        // Log the creation of the certification
        emit certifCreation(idCert);
        // Return the certification's ID
        return idCert;
    }

    // Function to create a new certification and template
    function insertWithoutTemplate(
        string memory _cfied_firstname,
        string memory _cfied_lastname,
        string memory _cfied_birthdate,
        string memory _cfier_name,
        string memory _cfier_adress,
        address _certified_pub_adress,
        string memory _title,
        string memory _name,
        string memory _date,
        string[] memory _specs
    ) public returns (bytes32) {
        // Generate a unique ID for the certification using the createhashOwner function
        bytes32 idCert = createhashOwner(_certified_pub_adress);

        // Store the certification data in the map
        map_cert[idCert] = Certification(
            msg.sender,
            _certified_pub_adress,
            Certified(_cfied_firstname, _cfied_lastname, _cfied_birthdate),
            Certifier(_cfier_name, _cfier_adress),
            Template(_title, _name, _date, _specs)
        );
        // Set the certification to be visible
        studentVisibility[idCert] = true;
        // Log the creation of the certification
        emit certifCreation(idCert);
        // Return the certification's ID
        return idCert;
    }

    // Function to modify an existing certification
    function modifyCertification(
        bytes32 _idCert,
        string memory _cfied_firstname,
        string memory _cfied_lastname,
        string memory _cfied_birthdate,
        string memory _cfier_name,
        string memory _cfier_adress,
        string memory _title,
        string memory _name,
        string memory _date,
        string[] memory _specs
    ) public {
        // Retrieve the certification data from the map
        Certification storage certif = map_cert[_idCert];
        // Check if the caller is the owner of the certification
        require(certif.dip_addr_certifier == msg.sender, "You are not the owner of this certification.");
        // Update the certification data
        certif.dip_addr_certified = msg.sender;
        certif.dip_certified = Certified(_cfied_firstname, _cfied_lastname, _cfied_birthdate);
        certif.dip_cedrtifier = Certifier(_cfier_name, _cfier_adress);
        certif.dip_template = Template(_title, _name, _date, _specs);
        // Log the modification of the certification
        emit modificationMsg("The certification has been modified.");
    }

    // Function to delete an existing certification
    function deleteCertification(bytes32 _idCert) public {
        // Retrieve the certification data from the map
        Certification storage certif = map_cert[_idCert];
        // Check if the caller is the owner of the certification
        require(certif.dip_addr_certifier == msg.sender, "You are not the owner of this certification.");
        // Delete the certification data from the map
        delete map_cert[_idCert];
        // Log the deletion of the certification
        emit deletedCertif("The certification has been deleted.");
    }

    // Function to retrieve the data for a certified individual
    function getCertified(bytes32 _idCert)
        public
        view
        returns (Certified memory)
    {
        // Retrieve the certification data from the map
        Certification storage certif = map_cert[_idCert];
        // Check if the certification is set to be visible
        if (studentVisibility[_idCert]) {
            // Return the certified individual's data
            return certif.dip_certified;
        } else {
            // Return default data for an unknown individual
            return unknowCertifed;
        }
    }

    // Function to retrieve the data for a certification
    function getCertification(bytes32 _idCert)
        public
        view
        returns (Certification memory)
    {
        // Retrieve the certification data from the map
        Certification storage certif = map_cert[_idCert];
        // Check if the certification is set tobe visible
        if (studentVisibility[_idCert]) {
            // Return the certification data
            return certif;
        } else {
            // Return default data for an unknown certification
            return Certification(
                address(0),
                address(0),
                unknowCertifed,
                Certifier("unknown", "unknown"),
                Template("unknown", "unknown", "unknown", new string[](0))
            );
        }
    }

    // Function to set the visibility of a certification
    function setVisibility(bytes32 _idCert, bool _visibility) public {
        // Retrieve the certification data from the map
        Certification storage certif = map_cert[_idCert];
        // Check if the caller is the owner of the certification
        require(certif.dip_addr_certifier == msg.sender, "You are not the owner of this certification.");
        // Update the visibility of the certification
        studentVisibility[_idCert] = _visibility;
        // Log the change in visibility
        emit evtVisisbility("The visibility of the certification has been changed.");
    }
}
