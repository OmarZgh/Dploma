# Contrat Dploma
Ce contrat permet de créer, stocker et récupérer des certifications.

## Structures de données

### Certification
Cette structure représente les données d'une certification. Elle contient les champs suivants:

- `dip_addr_certifier`: l'adresse du certifieur
- `dip_addr_certified`: l'adresse de la personne certifiée
- `dip_certified`: les données sur la personne certifiée (voir la structure Certified)
- `dip_cedrtifier`: les données sur le certifieur (voir la structure Certifier)
- `dip_template`: les données sur le modèle utilisé pour la certification (voir la structure Template)
  
### Template
Cette structure représente les données d'un modèle. Elle contient les champs suivants:

- `temp_title`: le titre du modèle
- `temp_name`: le nom du modèle
- `temp_date`: la date du modèle
- `temp_spec`: les spécifications du modèle

### Certified

Cette structure représente les données sur la personne certifiée. Elle contient les champs suivants:

- `cfied_firstname`: le prénom de la personne certifiée
- `cfied_lastname`: le nom de famille de la personne certifiée
- `cfied_birthdate`: la date de naissance de la personne certifiée

### Certifier

Cette structure représente les données sur le certifieur. Elle contient les champs suivants:

- `cfier_name`: le nom du certifieur
- `cfier_adress`: l'adresse du certifieur

## Fonctions

### createhashOwner(address _addrS)

Cette fonction privée génère un ID unique pour une certification en utilisant l'adresse de la personne certifiée, l'adresse de l'appelant et le timestamp du bloc actuel.

### createTemplate(string _title, string _name, string _date, string[] _specs)

Cette fonction permet de créer un nouveau modèle de certification en enregistrant ses données dans la map `map_temp`. Un ID unique est généré pour le modèle en utilisant la fonction keccak256.

### getTemplate(bytes32 _hashTemplate)

Cette fonction permet de récupérer les données d'un modèle en utilisant son ID.

### insertWithTemplate(string _cfied_firstname, string _cfied_lastname, string _cfied_birthdate, string _cfier_name, string _cfier_adress, bytes32 _hashTemplate, address _certified_pub_adress)

Cette fonction permet de créer une nouvelle certification en utilisant un modèle existant. Les données sur la certification et la personne certifiée sont enregistrées dans la map `map_cert`. Un ID unique est généré pour la certification en utilisant la fonction `createhashOwner`.

### insertWithoutTemplate(string _cfied_firstname, string _cfied_lastname, string _cfied_birthdate, string _cfier_name, string _cfier_adress, address _certified_pub_adress, string _title, string _name, string _date, string[] _specs)

Cette fonction permet de créer une nouvelle certification en utilisant un modèle qui est créé en même temps. Les données sur la certification, la personne certifiée et le modèle sont enregistrées dans la map `map_cert`. Un ID unique est généré pour la certification en utilisant la fonction `createhashOwner`.

### modifyCertification(bytes32 _idCert, string _cfied_firstname, string _cfied_lastname, string _cfied_birth

date, string _cfier_name, string _cfier_adress, string _title, string _name, string _date, string[] _specs)

Cette fonction permet de modifier une certification existante. Les données sur la certification et la personne certifiée sont mises à jour dans la map `map_cert`. Seul l'appelant peut effectuer cette action.

### deleteCertification(bytes32 _idCert)

Cette fonction permet de supprimer une certification existante de la map `map_cert`. Seul l'appelant peut effectuer cette action.

### getCertified(bytes32 _idCert)

Cette fonction permet de récupérer les données sur la personne certifiée à partir de l'ID de la certification. Si la certification est définie comme visible dans la map `studentVisibility`, les données sont retournées. Sinon, des données par défaut sont retournées pour une personne inconnue.

### getCertification(bytes32 _idCert)

Cette fonction permet de récupérer les données sur une certification à partir de son ID. Si la certification est définie comme visible dans la map `studentVisibility`, les données sont retournées. Sinon, des données par défaut sont retournées pour une certification inconnue.

### setVisibility(bytes32 _idCert, bool _visibility)

Cette fonction permet de définir la visibilité d'une certification dans la map `studentVisibility`. Seul l'appelant peut effectuer cette action.

## Événements

### evtTemplate(bytes32)

Cet événement est déclenché lorsqu'un nouveau modèle est créé. Il fournit l'ID du modèle.

### certifCreation(bytes32)

Cet événement est déclenché lorsqu'une nouvelle certification est créée. Il fournit l'ID de la certification.

### modificationMsg(string)

Cet événement est déclenché lorsqu'une certification est modifiée. Il fournit un message indiquant que la modification a été effectuée.

### evtVisisbility(string)

Cet événement est déclenché lorsque la visibilité d'une certification est modifiée. Il fournit un message indiquant que la visibilité a été modifiée.

### deletedCertif(string)

Cet événement est déclenché lorsqu'une certification est supprimée. Il fournit un message indiquant que la certification a été supprimée.
