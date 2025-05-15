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
