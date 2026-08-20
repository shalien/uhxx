[Manager]s provide deserialization and Dart APIs that correspond to Discord's
HTTP endpoints. Each [Manager] is usually responsible for one or more kind of
[Entity] and will provide parsing for [Models] related to that [Entity]. Some
managers may not manage a specific kind of [Entity] and instead will simply wrap
a group of related HTTP endpoints.

[Manager]s also provide [Cache]s for the [Entities] they manage. These can be
accessed using [Manager.cache] and [Manager.get].

Managers usually expose at least the following APIs:
- [Manager.get] to fetch an entity using the cache if possible.
- [Manager.fetch] to fetch an entity while bypassing the cache.
- [Manager.parse] to parse a JSON map to an entity (usually only called
  internally by `uhxx`).

Managers that are not [ReadOnlyManager]s also expose the following APIs:
- [Manager.create] to create a new entity.
- [Manager.update] to update an entity.
- [Manager.delete] to delete an entity.

Most managers will expose additional methods specific to the type of entity they
manage.

Managers that support creation and updating will use [Builders] to specify how
the entity should be created or updated.

Many manager methods can be accessed directly on partial [Entities], often
leading to cleaner code. For more information, see the [Entities] topic.

[Manager]: ../uhxx/Manager-class.html
[Models]: ./models-topic.html
[Entity]: ./entities-topic.html
[Cache]: ../uhxx/Cache-class.html
[Entities]: ./entities-topic.html
[Manager.cache]: ../uhxx/ReadOnlyManager/cache.html
[Manager.get]: ../uhxx/ReadOnlyManager/get.html
[Manager.fetch]: ../uhxx/ReadOnlyManager/fetch.html
[Manager.parse]: ../uhxx/ReadOnlyManager/parse.html
[ReadOnlyManager]: ../uhxx/ReadOnlyManager-class.html
[Manager.create]: ../uhxx/Manager/create.html
[Manager.update]: ../uhxx/Manager/update.html
[Manager.delete]: ../uhxx/Manager/delete.html
[Builders]: ./builders-topic.html
