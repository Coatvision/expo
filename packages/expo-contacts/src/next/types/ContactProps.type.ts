import { Email, Date, Address, Phone, Relation, UrlAddress } from './Contact.type';

/**
 * Denotes the functionality of a native contact form.
 * @platform ios
 */
export type FormOptions = {
  /**
   * The properties that will be displayed when viewing a contact.
   */
  displayedPropertyKeys?: ContactField[];
  /**
   * The message displayed under the name of the contact. Only applies when editing an existing contact.
   */
  message?: string;
  /**
   * Used if contact doesn't have a name defined.
   */
  alternateName?: string;
  /**
   * Allows for contact mutation.
   */
  allowsEditing?: boolean;
  /**
   * Actions like share, add, create.
   */
  allowsActions?: boolean;
  /**
   * Show or hide the similar contacts.
   */
  shouldShowLinkedContacts?: boolean;
  /**
   * Present the new contact controller. If set to `false` the unknown controller will be shown.
   */
  isNew?: boolean;
  /**
   * The name of the left bar button. Only applies when editing an existing contact.
   */
  cancelButtonTitle?: string;
  /**
   * Prevents the controller from animating in.
   */
  preventAnimation?: boolean;
  /**
   * The parent group for a new contact.
   */
  groupId?: string;
};

export enum ContactField {
  GIVEN_NAME = 'givenName',
  MIDDLE_NAME = 'middleName',
  FAMILY_NAME = 'familyName',
  MAIDEN_NAME = 'maidenName',
  NICKNAME = 'nickname',
  PREFIX = 'prefix',
  SUFFIX = 'suffix',
  PHONETIC_GIVEN_NAME = 'phoneticGivenName',
  PHONETIC_MIDDLE_NAME = 'phoneticMiddleName',
  PHONETIC_FAMILY_NAME = 'phoneticFamilyName',
  COMPANY = 'company',
  DEPARTMENT = 'department',
  JOB_TITLE = 'jobTitle',
  NOTE = 'note',
  IMAGE = 'image',
  EMAILS = 'emails',
  PHONES = 'phones',
  ADDRESSES = 'addresses',
  EXTRA_NAMES = 'extraNames',
  DATES = 'dates',
  RELATIONS = 'relations',
  URL_ADDRESSES = 'urlAddresses',
}

export type CreateContactRecord = {
  givenName?: string | null;
  middleName?: string;
  familyName?: string;
  maidenName?: string;
  nickname?: string;
  prefix?: string;
  suffix?: string;
  phoneticGivenName?: string;
  phoneticMiddleName?: string;
  phoneticFamilyName?: string;
  company?: string;
  department?: string;
  jobTitle?: string;
  isFavourite?: boolean;
  note?: string;
  image?: string;
  emails?: Email.New[];
  dates?: Date.New[];
  phones?: Phone.New[];
  addresses?: Address.New[];
  relations?: Relation.New[];
  urlAddresses?: UrlAddress.New[];
};

export type ContactDetails = {
  givenName?: string | null;
  middleName?: string;
  familyName?: string;
  maidenName?: string;
  nickname?: string;
  prefix?: string;
  suffix?: string;
  phoneticGivenName?: string;
  phoneticMiddleName?: string;
  phoneticFamilyName?: string;
  company?: string;
  department?: string;
  jobTitle?: string;
  note?: string;
  image?: string;
  emails?: Email.New[];
  dates?: Date.New[];
  phones?: Phone.New[];
  extraNames?: string[];
  addresses?: Address.New[];
  relations?: Relation.New[];
  urlAddresses?: UrlAddress.New[];
};

export type ContactFieldKey = {
  [ContactField.GIVEN_NAME]: 'givenName';
  [ContactField.MIDDLE_NAME]: 'middleName';
  [ContactField.FAMILY_NAME]: 'familyName';
  [ContactField.MAIDEN_NAME]: 'maidenName';
  [ContactField.NICKNAME]: 'nickname';
  [ContactField.PREFIX]: 'prefix';
  [ContactField.SUFFIX]: 'suffix';
  [ContactField.PHONETIC_GIVEN_NAME]: 'phoneticGivenName';
  [ContactField.PHONETIC_MIDDLE_NAME]: 'phoneticMiddleName';
  [ContactField.PHONETIC_FAMILY_NAME]: 'phoneticFamilyName';
  [ContactField.COMPANY]: 'company';
  [ContactField.DEPARTMENT]: 'department';
  [ContactField.JOB_TITLE]: 'jobTitle';
  [ContactField.NOTE]: 'note';
  [ContactField.IMAGE]: 'image';
  [ContactField.EMAILS]: 'emails';
  [ContactField.PHONES]: 'phones';
  [ContactField.ADDRESSES]: 'addresses';
  [ContactField.DATES]: 'dates';
  [ContactField.EXTRA_NAMES]: 'extraNames';
  [ContactField.RELATIONS]: 'relations';
  [ContactField.URL_ADDRESSES]: 'urlAddresses';
};

export type PartialContactDetails<T extends readonly ContactField[]> = {
  id: string;
} & {
  [K in T[number]]: ContactDetails[K];
};
