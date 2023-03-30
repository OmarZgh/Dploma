# Dploma

## Description

The Dploma contract is an Ethereum contract that allows you to create and store digital credentials. A certification is composed of data about the model used, the certifier and the certified. The certifier can choose to make his certification visible or not to other users.

## Features

Here are the features of this contract :

- `Creating certification templates`: a user can create a certification template by specifying its title, name, date and specifications.
- `Adding certifications with a template`: a user can add a certification using an existing template by specifying the certifier and the certifier information.
- `Adding certifications without template`:a user can add a certification by creating a new template by specifying the information of the certified, the certifier and the template.
- `Modification of certifications`: A certifier can modify the information of a certification.
- `Deletion of certifications`: A certifier can delete a certification. 
- `Visibility of certifications`: lthe certifier can choose to make visible or not his data in his certification to other users.

## Data structures

Here are the data structures used in this contract :

### Certification

This structure represents the data of a certification. It contains the following fields :

- `dip_addr_certifier`: the Ethereum address of the certifier.
- `dip_addr_certified`: the Ethereum address of the certified person.
- `dip_certified`: the data about the certified person (see the Certified structure).
- `dip_cedrtifier`: data about the certifier (see the Certifier structure).
- `dip_template`: data about the template used for the certification (see the Template structure).
  
### Template

This structure represents the data of a template. It contains the following fields:

- `temp_title`: the title of the template.
- `temp_name`: the name of the template.
- `temp_date`: the date of the template.
- `temp_spec`: the specifications of the model.

### Certified

Cette structure représente les données sur la personne certifiée. Elle contient les champs suivants :

- `cfied_firstname`: le prénom de la personne certifiée.
- `cfied_lastname`: le nom de famille de la personne certifiée.
- `cfied_birthdate`: la date de naissance de la personne certifiée.

### Certifier

This structure represents the data on the certified person. It contains the following fields:

- `cfied_firstname`: the first name of the certified person.
- `cfied_lastname`: the last name of the certified person.
- `cfied_birthdate`: the date of birth of the certified person.

### Certifier

This structure represents the data about the certifier. It contains the following fields:

- `cfier_name`: the name of the certifier.
- `cfier_adress`: the address of the certifier.

## Mappings

Here are the mappings used in this contract:

- `map_cert`: mapping of the Certification structure that associates a unique identifier (computed from the holder's Ethereum address and the transaction timestamp) with a certification.
- `map_temp`: mapping of the Template structure that associates a unique identifier (computed from the incremented template identifier) to a template.
- `unvisibleCertified`: mapping of the Certified structure which associates a unique identifier to a certified person. This mapping is only used when the certified person has chosen to make their data not visible to other users.
- `studentVisibility`: boolean mapping that associates a unique identifier with a boolean indicating whether or not the certified person's information is visible to other users.

## Events

Here are the events triggered by this contract:

- `evtTemplate`: triggered when a template is created, with the unique identifier of the template as a parameter.
- `certifCreation`: triggered when a certification is added, with the unique identifier of the certification as parameter.
- `modificationMsg`: triggered when a certification is modified, with a message informing about the modification.
- `evtVisibility`: triggered when the visibility of a certification is modified, with a message informing of the modification.
- `deletedCertif`: triggered when a certification is deleted, with a message informing about the deletion.

## Functions

Here are the functions of this contract:

### createhashOwner(address _addrS)

This private function generates a unique ID for a certification using the address of the certified person, the address of the caller and the timestamp of the current block.

### createTemplate(string _title, string _name, string _date, string[] _specs)

This function creates a new certification template by storing its data in the map `map_temp`. A unique ID is generated for the template using the keccak256 function.

### getTemplate(bytes32 _hashTemplate)

This function retrieves data from a template using its ID.

### insertWithTemplate(string _cfied_firstname, string _cfied_lastname, string _cfied_birthdate, string _cfier_name, string _cfier_adress, bytes32 _hashTemplate, address _certified_pub_adress)

This function creates a new certification using an existing template. The data about the certification and the certified person are stored in the map `map_cert`. A unique ID is generated for the certification using the `createhashOwner` function.

### insertWithoutTemplate(string _cfied_firstname, string _cfied_lastname, string _cfied_birthdate, string _cfier_name, string _cfier_adress, address _certified_pub_adress, string _title, string _name, string _date, string[] _specs)

This function creates a new certification using a template that is created at the same time. The data about the certification, the certified person and the template are stored in the map `map_cert`. A unique ID is generated for the certification using the `createhashOwner` function.

### toggleStudentVisibility(bytes32 _idCert, bool _visibility)

This function allows to set the visibility of a certification in the `studentVisibility` map. Only the certified person can perform this action.

### getCertification(bytes32 _idCert)

This function retrieves data about a certification from its ID. If the certification is defined as visible in the `studentVisibility` map, the data is returned. Otherwise, the default data is returned for an unknown certified person.

### ModifyTemplate(bytes32 _hashCert, string _title, string _name, string _date date, string[] _specs)

This function allows to modify an existing template. The data are updated in the map `map_cert`. Only the certifier can perform this action.

### deleteCertif(bytes32 _idCert)

This function deletes an existing certificate from the map `map_cert`. Only the certifier can perform this action.

