## v2.4.0 - Aug 3, 2026

- Added theme mutation endpoints: `Themes.create()` and `Themes.update()`.
- Added component mutation endpoints: `Components.create()` and `Components.update()`.
- Added `AudienceSegments.create()`.
- Added `EmailMessages.run_guardian()` for Guardian content validation.
- Added event pattern endpoints: `EventPatterns.list()`, `.get()`, and `.get_by_name()`.
- Added workflow mutation endpoints: `Workflows.create()`, `.update()`, and `.change_mailing_list()`.
- Added workflow node endpoints: `Workflows.create_node()`, `.update_node()`, `.delete_node()`, `.add_branch()`, and `.delete_node_recursive()`.

## v2.3.0 - Jun 24, 2026

- Added `Uploads.upload()` to upload an image.
- Added transactional email content endpoints: `Transactional.create()`, `.get()`, `.update()`, `.ensure_draft()`, and `.publish()`. `Transactional.list()` returns a new data shape.
- Added audience segment endpoints: `AudienceSegments.list()` and `.get()`.
- Added workflow endpoints: `Workflows.list()`, `.get()`, and `.get_node()`.
- Added campaign group endpoints: `CampaignGroups.list()`, `.create()`, `.get()`, and `.update()`.
- Added transactional group endpoints: `TransactionalGroups.list()`, `.create()`, `.get()`, and `.update()`.
- Added `EmailMessages.preview()` for sending test previews.
- Extended `Campaigns.create()` and `.update()` with audience, group, and scheduling fields.
- Extended `EmailMessages.update()` with CC/BCC, language, format, and fallback fields.

## v2.2.0 - May 21, 2026

- Added support for campaigns, email messages, themes, components, and dedicated sending IP endpoints.
- THe SDK now treats `201` responses as success and raises `APIError` for new `401`, `413`, and `422` responses.

## v2.1.0 - Aug 8, 2026

- Added support for contact suppression endpoints with `Contacts.check_suppression()` and `Contacts.remove_suppression()`.

## v2.0.0 - Aug 22, 2025

Added support for using either `email` or `user_id` with `Contacts.update()`.

## v1.2.1 - May 22, 2025

Fixed issue with `GET` API requests.

## v1.2.0 - May 15, 2025

- Added a `headers` parameter for `Events.send()` and `Transactional.send()`, enabling support for the `Idempotency-Key` header.
- Added test suite and a tests for `Events` and `Transactional` classes.

## v1.1.0 - Feb 27, 2025

Added support for new List transactionals endpoint with `Transactional.list()`.

## v1.0.0 - Feb 26, 2025

- JSON from API errors is now accessible from the `APIError` class.
- Added support for two new contact property endpoints: `ContactProperties.create()` and `ContactProperties.list()`.
- Deprecated and removed the `CustomFields.list()` method (you can now use `ContactProperties.list()` instead).

## v0.2.0 - Oct 29, 2024

Added rate limit handling with `RateLimitError`.

## v0.1.2 - Aug 16, 2024

Support for resetting contact properties with `nil`.

## v0.1.1 - Aug 16, 2024

Added `ApiKey.test` method for testing API keys.

## v0.1.0 - Aug 16, 2024

Initial release.
