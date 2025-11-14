import ExpoModulesCore
import Contacts

class Container: SharedObject {
  let id: String
  private let containerRepository: ContainerRepository
  private let contactRepository: ContactRepository
  private let groupRepository: GroupRepository
  private let contactFactory: ContactFactory

  init(
    id: String,
    containerRepository: ContainerRepository,
    contactRepository: ContactRepository,
    groupRepository: GroupRepository,
    contactFactory: ContactFactory
  ) {
    self.id = id
    self.containerRepository = containerRepository
    self.contactRepository = contactRepository
    self.groupRepository = groupRepository
    self.contactFactory = contactFactory
  }

  func name() throws -> String? {
    let container = try containerRepository.getById(id: id)
    return container?.name
  }

  func type() throws -> String? {
    let container = try containerRepository.getById(id: id)
    switch container?.type {
    case .local: return "local"
    case .exchange: return "exchange"
    case .cardDAV: return "cardDAV"
    case .unassigned: return "unassigned"
    default: return "unknown"
    }
  }

  func getGroups() throws -> [Group] {
    // Wykorzystujemy istniejącą metodę w GroupRepository, która filtruje po containerId
    // Zakładam, że masz metodę getAll(containerId:) w GroupRepository
    let groups = try groupRepository.getAll(containerId: id)
    return groups.map {
      Group(
        id: $0.identifier,
        groupRepository: groupRepository,
        contactRepository: contactRepository,
        contactFactory: contactFactory
      )
    }
  }

  func getContacts() throws -> [ContactNext] {
    let contacts = try contactRepository.getByContainerId(
      containerId: id,
      keysToFetch:[CNContactIdentifierKey as CNKeyDescriptor]
    )
    
    return contacts.map {
      contactFactory.create(id: $0.identifier)
    }
  }

  static func getAll(
    containerRepository: ContainerRepository,
    contactRepository: ContactRepository,
    groupRepository: GroupRepository,
    contactFactory: ContactFactory
  ) throws -> [Container] {
    let containers = try containerRepository.getAll()
    return containers.map {
      Container(
        id: $0.identifier,
        containerRepository: containerRepository,
        contactRepository: contactRepository,
        groupRepository: groupRepository,
        contactFactory: contactFactory
      )
    }
  }

  static func getDefault(
    containerRepository: ContainerRepository,
    contactRepository: ContactRepository,
    groupRepository: GroupRepository,
    contactFactory: ContactFactory
  ) throws -> Container? {
    guard let container = try containerRepository.getDefault() else {
      return nil
    }
    return Container(
      id: container.identifier,
      containerRepository: containerRepository,
      contactRepository: contactRepository,
      groupRepository: groupRepository,
      contactFactory: contactFactory
    )
  }
}
