import ExpoModulesCore

enum ContactField: String, Enumerable {
  case GIVEN_NAME = "givenName"
  case MIDDLE_NAME = "middleName"
  case FAMILY_NAME = "familyName"
  case PREFIX = "prefix"
  case SUFFIX = "suffix"
  case PHONETIC_GIVEN_NAME = "phoneticGivenName"
  case PHONETIC_MIDDLE_NAME = "phoneticMiddleName"
  case PHONETIC_FAMILY_NAME = "phoneticFamilyName"
  case NICKNAME = "nickname"
  case COMPANY = "company"
  case DEPARTMENT = "department"
  case JOB_TITLE = "jobTitle"
  case PHONETIC_COMPANY_NAME = "phoneticCompanyName"
  case IMAGE = "image"
  case EMAILS = "emails"
  case PHONES = "phones"
  case ADDRESSES = "addresses"
  case DATES = "dates"
  case RELATIONS = "relations"
  case URL_ADDRESSES = "urlAddresses"
  // iOS fields:
  case BIRTHDAY = "birthday"
  case NON_GREGORIAN_BIRTHDAY = "nonGregorianBirthday"
  // Android fields:
  case EXTRA_NAMES = "extraNames"
}
