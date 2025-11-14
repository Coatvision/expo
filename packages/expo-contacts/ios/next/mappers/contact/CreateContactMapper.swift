import Contacts

class CreateContactMapper {
  static func toCNMutableContact(_ createContactRecord: CreateContactRecord, _ imageData: Data?) -> CNMutableContact {
    let contact = CNMutableContact()
    contact.givenName = createContactRecord.givenName ?? ""
    contact.middleName = createContactRecord.middleName ?? ""
    contact.familyName = createContactRecord.familyName ?? ""
        
    contact.previousFamilyName = createContactRecord.maidenName ?? ""
    contact.nickname = createContactRecord.nickname ?? ""
    contact.namePrefix = createContactRecord.prefix ?? ""
    contact.nameSuffix = createContactRecord.suffix ?? ""
        
    contact.phoneticGivenName = createContactRecord.phoneticGivenName ?? ""
    contact.phoneticMiddleName = createContactRecord.phoneticMiddleName ?? ""
    contact.phoneticFamilyName = createContactRecord.phoneticFamilyName ?? ""
        
    contact.organizationName = createContactRecord.company ?? ""
    contact.jobTitle = createContactRecord.jobTitle ?? ""
    contact.departmentName = createContactRecord.department ?? ""
    contact.phoneticOrganizationName = createContactRecord.phoneticOrganizationName ?? ""
        
    contact.note = createContactRecord.note ?? ""
    
    if let imageData = imageData {
      contact.imageData = imageData
    }
    
    if let emails = createContactRecord.emails {
      let mapper = EmailMapper()
      contact.emailAddresses = emails.map { email in
        return mapper.newRecordToCNLabeledValue(email)
      }
    }
      
    if let dates = createContactRecord.dates {
      let mapper = DateMapper()
      contact.dates = dates.map { date in
        return mapper.newRecordToCNLabeledValue(date)
      }
    }
    
    if let phones = createContactRecord.phones {
      let mapper = PhoneMapper()
      contact.phoneNumbers = phones.map { phone in
        return mapper.newRecordToCNLabeledValue(phone)
      }
    }
    
    if let addresses = createContactRecord.addresses {
      let mapper = PostalAddressMapper()
      contact.postalAddresses = addresses.map { address in
        return mapper.newRecordToCNLabeledValue(address)
      }
    }
    
    if let relations = createContactRecord.relations {
      let mapper = RelationMapper()
      contact.contactRelations = relations.map { relation in
        return mapper.newRecordToCNLabeledValue(relation)
      }
    }
    
    if let urlAddresses = createContactRecord.urlAddresses {
      let mapper = UrlAddressMapper()
      contact.urlAddresses = urlAddresses.map { urlAddress in
        return mapper.newRecordToCNLabeledValue(urlAddress)
      }
    }
    return contact
  }
}
