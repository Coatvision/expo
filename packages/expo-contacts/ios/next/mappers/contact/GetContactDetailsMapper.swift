import Foundation
import Contacts
import ExpoModulesCore

class GetContactDetailsMapper {
  func map(contact: CNContact, keys: [CNKeyDescriptor], imageUri: String?) -> GetContactDetailsRecord {
    let keySet = Set(keys.map { $0 as! String })
    
    return GetContactDetailsRecord(
      id: contact.identifier,
      
      givenName: keySet.contains(CNContactGivenNameKey) ? (contact.givenName == "" ? nil : contact.givenName) : nil,
      middleName: keySet.contains(CNContactMiddleNameKey) ? (contact.middleName == "" ? nil : contact.middleName) : nil,
      familyName: keySet.contains(CNContactFamilyNameKey) ? (contact.familyName == "" ? nil : contact.familyName) : nil,
      maidenName: keySet.contains(CNContactPreviousFamilyNameKey) ? (contact.previousFamilyName == "" ? nil : contact.previousFamilyName) : nil,
      nickname: keySet.contains(CNContactNicknameKey) ? (contact.nickname == "" ? nil : contact.nickname) : nil,
      prefix: keySet.contains(CNContactNamePrefixKey) ? (contact.namePrefix == "" ? nil : contact.namePrefix) : nil,
      suffix: keySet.contains(CNContactNameSuffixKey) ? (contact.nameSuffix == "" ? nil : contact.nameSuffix) : nil,
      phoneticGivenName: keySet.contains(CNContactPhoneticGivenNameKey) ? (contact.phoneticGivenName == "" ? nil : contact.phoneticGivenName) : nil,
      phoneticMiddleName: keySet.contains(CNContactPhoneticMiddleNameKey) ? (contact.phoneticMiddleName == "" ? nil : contact.phoneticMiddleName) : nil,
      phoneticFamilyName: keySet.contains(CNContactPhoneticFamilyNameKey) ? (contact.phoneticFamilyName == "" ? nil : contact.phoneticFamilyName) : nil,
      company: keySet.contains(CNContactOrganizationNameKey) ? (contact.organizationName == "" ? nil : contact.organizationName) : nil,
      department: keySet.contains(CNContactDepartmentNameKey) ? (contact.departmentName == "" ? nil : contact.departmentName) : nil,
      jobTitle: keySet.contains(CNContactJobTitleKey) ? (contact.jobTitle == "" ? nil : contact.jobTitle) : nil,
      phoneticCompanyName: keySet.contains(CNContactPhoneticOrganizationNameKey) ? (contact.phoneticOrganizationName == "" ? nil : contact.phoneticOrganizationName) : nil,
      note: keySet.contains(CNContactNoteKey) ? (contact.note == "" ? nil : contact.note) : nil,
      image: keySet.contains(CNContactImageDataKey) ? imageUri : nil,

      emails: keySet.contains(CNContactEmailAddressesKey)
      ? contact.emailAddresses.map { EmailMapper().cnLabeledValueToExistingRecord($0) }
      : nil,
      
      dates: keySet.contains(CNContactDatesKey)
      ? contact.dates.map { DateMapper().cnLabeledValueToExistingRecord($0) }
      : nil,
      
      phones: keySet.contains(CNContactPhoneNumbersKey)
      ? contact.phoneNumbers.map { PhoneMapper().cnLabeledValueToExistingRecord($0) }
      : nil,
      
      addresses: keySet.contains(CNContactPostalAddressesKey)
      ? contact.postalAddresses.map { PostalAddressMapper().cnLabeledValueToExistingRecord($0) }
      : nil,
      
      relations: keySet.contains(CNContactRelationsKey)
        ? contact.contactRelations.map { RelationMapper().cnLabeledValueToExistingRecord($0) }
        : nil,
      
      urlAddresses: keySet.contains(CNContactUrlAddressesKey)
        ? contact.urlAddresses.map { UrlAddressMapper().cnLabeledValueToExistingRecord($0) }
        : nil
    )
  }
}
