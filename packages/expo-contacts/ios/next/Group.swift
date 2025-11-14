import ExpoModulesCore
import Contacts

class Group: SharedObject {
  let id: String
  private let groupRepository: GroupRepository
  private let contactRepository: ContactRepository
  private let contactFactory: ContactFactory

  init(
    id: String,
    groupRepository: GroupRepository,
    contactRepository: ContactRepository,
    contactFactory: ContactFactory
  ) {
    self.id = id
    self.groupRepository = groupRepository
    self.contactRepository = contactRepository
    self.contactFactory = contactFactory
  }

  func name() throws -> String? {
    let group = try groupRepository.getById(groupId: id)
    return group?.name
  }

  func getContacts() throws -> [ContactNext] {
    let keys = [CNContactIdentifierKey as CNKeyDescriptor]
    let contacts = try contactRepository.getByGroupId(groupId: id, keysToFetch: keys)
    return contacts.map {
      contactFactory.create(id: $0.identifier)
    }
  }

  func addContact(contact: ContactNext) throws {
    guard let group = try groupRepository.getById(groupId: id) else {
      throw GroupNotFoundException(id)
    }

    guard let cnContact = contactRepository.getById(id: contact.id, keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor]) else {
      throw ContactNotFoundException(contact.id)
    }

    try groupRepository.addMember(contact: cnContact, to: group)
  }

  func removeContact(contact: ContactNext) throws {
    guard let group = try groupRepository.getById(groupId: id) else {
      throw GroupNotFoundException(id)
    }

    guard let cnContact = contactRepository.getById(id: contact.id, keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor]) else {
      throw ContactNotFoundException(contact.id)
    }

    try groupRepository.removeMember(contact: cnContact, from: group)
  }

  func updateName(_ newName: String) throws {
    let mutableGroup = try groupRepository.getMutableById(id: id)
    mutableGroup.name = newName
    try groupRepository.update(group: mutableGroup)
  }

  func delete() throws {
    try groupRepository.delete(id: id)
  }

  static func create(
    name: String,
    containerId: String?,
    groupRepository: GroupRepository,
    contactRepository: ContactRepository,
    contactFactory: ContactFactory
  ) throws -> Group {
    let newGroup = CNMutableGroup()
    newGroup.name = name
    try groupRepository.insert(group: newGroup, containerId: containerId)
    return Group(
      id: newGroup.identifier,
      groupRepository: groupRepository,
      contactRepository: contactRepository,
      contactFactory: contactFactory
    )
  }

  static func getAll(
    containerId: String?,
    groupRepository: GroupRepository,
    contactRepository: ContactRepository,
    contactFactory: ContactFactory
  ) throws -> [Group] {
    let groups = try groupRepository.getAll(containerId: containerId)
    return groups.map {
      Group(
        id: $0.identifier,
        groupRepository: groupRepository,
        contactRepository: contactRepository,
        contactFactory: contactFactory
      )
    }
  }
}
