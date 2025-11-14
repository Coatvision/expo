import ExpoModulesCore
import Contacts

class ContactNext: SharedObject {
  let id: String
  let contactRepository: ContactRepository
  let imageService: ImageService

  init(
    id: String,
    contactRepository: ContactRepository,
    imageService: ImageService
  ) {
    self.id = id
    self.contactRepository = contactRepository
    self.imageService = imageService
  }

  private lazy var properties = PropertyFactory(
    contactId: id,
    contactRepository: contactRepository
  )

  lazy var givenName = properties.make(.givenName, mapper: StringMapper())
  lazy var middleName = properties.make(.middleName, mapper: StringMapper())
  lazy var familyName = properties.make(.familyName, mapper: StringMapper())
  lazy var nickname = properties.make(.nickname, mapper: StringMapper())
  lazy var maidenName = properties.make(.previousFamilyName, mapper: StringMapper())
  lazy var prefix = properties.make(.namePrefix, mapper: StringMapper())
  lazy var suffix = properties.make(.nameSuffix, mapper: StringMapper())
  lazy var phoneticGivenName = properties.make(.phoneticGivenName, mapper: StringMapper())
  lazy var phoneticMiddleName = properties.make(.phoneticMiddleName, mapper: StringMapper())
  lazy var phoneticFamilyName = properties.make(.phoneticFamilyName, mapper: StringMapper())
  lazy var company = properties.make(.organizationName, mapper: StringMapper())
  lazy var jobTitle = properties.make(.jobTitle, mapper: StringMapper())
  lazy var department = properties.make(.departmentName, mapper: StringMapper())
  lazy var phoneticCompanyName = properties.make(.phoneticOrganizationName, mapper: StringMapper())
  lazy var note = properties.make(.note, mapper: StringMapper())

  lazy var birthday = properties.make(.birthday, mapper: ContactDateMapper())
  lazy var nonGregorianBirthday = properties.make(.nonGregorianBirthday, mapper: NonGregorianBirthdayMapper())
  lazy var image = properties.make(.imageData, mapper: ImageMapper(service: imageService, filename: "\(id)-\(CNContactImageDataKey).png"))
  lazy var thumbnail = properties.make(.thumbnailImageData, mapper: ImageMapper(service: imageService, filename: "\(id)-\(CNContactThumbnailImageDataKey).png"))
  
  lazy var emails = properties.makeList(.emailAddresses, mapper: EmailMapper())
  lazy var phones = properties.makeList(.phoneNumbers, mapper: PhoneMapper())
  lazy var dates = properties.makeList(.dates, mapper: DateMapper())
  lazy var addresses = properties.makeList(.postalAddresses, mapper: PostalAddressMapper())
  lazy var relations = properties.makeList(.relations, mapper: RelationMapper())
  lazy var urlAddresses = properties.makeList(.urlAddresses, mapper: UrlAddressMapper())

  func delete() async throws -> Bool {
    try contactRepository.delete(id: id)
    return true
  }

  func getDetails(fields: [ContactField]?) throws -> GetContactDetailsRecord {
    let keys = CNKeyDescriptorMapper.map(from: fields ?? ContactField.allCases)
    guard let contact = contactRepository.getById(id: id, keysToFetch: keys) else {
      throw ContactNotFoundException(id)
    }
    return try ContactNext.buildDetailsRecord(
      contact: contact,
      keys: keys,
      imageService: self.imageService
    )
  }

  func patch(_ patchContactRecord: PatchContactRecord) throws {
    let keys = CNKeyDescriptorMapper.map(from: patchContactRecord)
    let mutableContact = try contactRepository.getMutableById(id: id, keysToFetch: keys)
    let updatedContact = try ContactPatcher.apply(patches: patchContactRecord, to: mutableContact)
    try contactRepository.update(contact: updatedContact)
  }

  func update(_ createContactRecord: CreateContactRecord) throws {
    let keys = [
      CNContactGivenNameKey,
      CNContactMiddleNameKey,
      CNContactFamilyNameKey,
      CNContactPreviousFamilyNameKey,
      CNContactNicknameKey,
      CNContactNamePrefixKey,
      CNContactNameSuffixKey,
      
      CNContactPhoneticGivenNameKey,
      CNContactPhoneticMiddleNameKey,
      CNContactPhoneticFamilyNameKey,
      
      CNContactOrganizationNameKey,
      CNContactDepartmentNameKey,
      CNContactJobTitleKey,
      CNContactPhoneticOrganizationNameKey,
      
      CNContactNoteKey,
      CNContactImageDataKey,
      
      CNContactEmailAddressesKey,
      CNContactPhoneNumbersKey,
      CNContactPostalAddressesKey,
      CNContactUrlAddressesKey,
      CNContactDatesKey,
      CNContactRelationsKey,
      CNContactSocialProfilesKey,
      CNContactInstantMessageAddressesKey
    ]
    let mutableContact = try contactRepository.getMutableById(id: id, keysToFetch: keys as [CNKeyDescriptor])
    var imageData: Data? = nil
    if let imageUri = createContactRecord.image {
      imageData = try imageService.imageData(from: imageUri)
    }
    let contact = CreateContactMapper.toCNMutableContact(createContactRecord, imageData)
    for key in keys {
      if (contact.isKeyAvailable(key)) {
        mutableContact.setValue(contact.value(forKey: key), forKey: key)
      }
    }
    try contactRepository.update(contact: mutableContact)
  }
  
  static func getAll(contactRepository: ContactRepository, contactFactory: ContactFactory) throws -> [ContactNext] {
    let contacts = try contactRepository.getAll(keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor])
    return contacts.map {
      contactFactory.create(id: $0.identifier)
    }
  }

  static func getAllDetails(
    fields: [ContactField]?,
    contactRepository: ContactRepository,
    imageService: ImageService
  ) throws -> [GetContactDetailsRecord] {
    let keys = CNKeyDescriptorMapper.map(from: fields ?? ContactField.allCases)
    let contacts = try contactRepository.getAll(keysToFetch: keys)
    return try contacts.map { contact in
      try buildDetailsRecord(contact: contact, keys: keys, imageService: imageService)
    }
  }

  static func create(
    createContactRecord: CreateContactRecord,
    contactRepository: ContactRepository,
    imageService: ImageService,
    contactFactory: ContactFactory
  ) throws -> ContactNext {
    var imageData: Data? = nil
    if let imageUri = createContactRecord.image {
      imageData = try imageService.imageData(from: imageUri)
    }

    let contact = CreateContactMapper.toCNMutableContact(createContactRecord, imageData)
    try contactRepository.insert(contact: contact)
    return contactFactory.create(id: contact.identifier)
  }
  
  private static func buildDetailsRecord(
    contact: CNContact,
    keys: [CNKeyDescriptor],
    imageService: ImageService
  ) throws -> GetContactDetailsRecord {
    var imageUri: String? = nil
    if contact.isKeyAvailable(CNContactImageDataKey), let imageData = contact.imageData {
      let filename = "\(contact.identifier)-\(CNContactImageDataKey).png"
      imageUri = try imageService.url(from: imageData, filename: filename)
    }
        
    return GetContactDetailsMapper().map(
      contact: contact,
      keys: keys,
      imageUri: imageUri
    )
  }
}
