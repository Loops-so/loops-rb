# Loops Ruby SDK

[![Gem Total Downloads](https://img.shields.io/gem/dt/loops_sdk?style=social)](https://rubygems.org/gems/loops_sdk)

## Introduction

This is the official Ruby SDK for [Loops](https://loops.so), an email platform for modern software companies.

## Installation

Install the gem and add it to the application's Gemfile like this:

```bash
bundle add loops_sdk
```

If bundler is not being used to manage dependencies, you can install the gem like this:

```bash
gem install loops_sdk
```

## Usage

You will need a Loops API key to use the package.

In your Loops account, go to the [API Settings page](https://app.loops.so/settings?page=api) and click **Generate key**.

Copy this key and save it in your application code (for example, in an environment variable).

See the API documentation to learn more about [rate limiting](https://loops.so/docs/api-reference#rate-limiting) and [error handling](https://loops.so/docs/api-reference#debugging).

In an initializer, import and configure the SDK:

```ruby config/initializers/loops.rb
require "loops_sdk"

LoopsSdk.configure do |config|
  config.api_key = 'your_api_key'
end
```

Then you can call methods in your code:

```ruby
begin
  response = LoopsSdk::Transactional.send(
    transactional_id: "closfz8ui02yq......",
    email: "dan@loops.so",
    data_variables: {
      loginUrl: "https://app.domain.com/login?code=1234567890"
    }
  )
  render json: response

rescue LoopsSdk::APIError => e
  # JSON returned by the API is in error.json and the HTTP code is in error.statusCode
  # Error messages explaining the issue can be found in error.json['message']
  Rails.logger.error("Loops API Error: #{e.json['message']} (Status: #{e.statusCode})")
end
```

## Handling rate limits

You can use the check for rate limit issues with your requests.

You can access details about the rate limits from the `limit` and `remaining` attributes.

```ruby
begin

  response = LoopsSdk::Contacts.update(
    email: "dan@loops.so"
  )

  render json: response

rescue LoopsSdk::RateLimitError => e
  Rails.logger.error("Rate limit exceeded (#{e.limit} requests per second)")
  # Code here to re-try this request
rescue LoopsSdk::APIError => e
  # Handle other errors
end
```

## Default contact properties

Each contact in Loops has a set of default properties. These will always be returned in API results.

- `id`
- `email`
- `firstName`
- `lastName`
- `source`
- `subscribed`
- `userGroup`
- `userId`
- `optInStatus`

## Custom contact properties

You can use custom contact properties in API calls. Please make sure to [add custom properties](https://loops.so/docs/contacts/properties#custom-contact-properties) in your Loops account before using them with the SDK.

## Methods

- [ApiKey.test()](#apikeytest)
- [Contacts.create()](#contactscreate)
- [Contacts.update()](#contactsupdate)
- [Contacts.find()](#contactsfind)
- [Contacts.delete()](#contactsdelete)
- [Contacts.check_suppression()](#contactscheck_suppression)
- [Contacts.remove_suppression()](#contactsremove_suppression)
- [ContactProperties.create()](#contactpropertiescreate)
- [ContactProperties.list()](#contactpropertieslist)
- [MailingLists.list()](#mailinglistslist)
- [Events.send()](#eventssend)
- [Transactional.list()](#transactionallist)
- [Transactional.create()](#transactionalcreate)
- [Transactional.get()](#transactionalget)
- [Transactional.update()](#transactionalupdate)
- [Transactional.ensure_draft()](#transactionalensure_draft)
- [Transactional.publish()](#transactionalpublish)
- [Transactional.send()](#transactionalsend)
- [DedicatedSendingIps.list()](#dedicatedsendingipslist)
- [Themes.list()](#themeslist)
- [Themes.get()](#themesget)
- [Themes.create()](#themescreate)
- [Themes.update()](#themesupdate)
- [Components.list()](#componentslist)
- [Components.get()](#componentsget)
- [Components.create()](#componentscreate)
- [Components.update()](#componentsupdate)
- [Campaigns.list()](#campaignslist)
- [Campaigns.create()](#campaignscreate)
- [Campaigns.get()](#campaignsget)
- [Campaigns.update()](#campaignsupdate)
- [CampaignGroups.list()](#campaigngroupslist)
- [CampaignGroups.create()](#campaigngroupscreate)
- [CampaignGroups.get()](#campaigngroupsget)
- [CampaignGroups.update()](#campaigngroupsupdate)
- [AudienceSegments.list()](#audiencesegmentslist)
- [AudienceSegments.get()](#audiencesegmentsget)
- [AudienceSegments.create()](#audiencesegmentscreate)
- [Workflows.list()](#workflowslist)
- [Workflows.create()](#workflowscreate)
- [Workflows.get()](#workflowsget)
- [Workflows.update()](#workflowsupdate)
- [Workflows.change_mailing_list()](#workflowschange_mailing_list)
- [Workflows.get_node()](#workflowsget_node)
- [Workflows.create_node()](#workflowscreate_node)
- [Workflows.update_node()](#workflowsupdate_node)
- [Workflows.delete_node()](#workflowsdelete_node)
- [Workflows.add_branch()](#workflowsadd_branch)
- [Workflows.delete_node_recursive()](#workflowsdelete_node_recursive)
- [EventPatterns.list()](#eventpatternslist)
- [EventPatterns.get()](#eventpatternsget)
- [EventPatterns.get_by_name()](#eventpatternsget_by_name)
- [EmailMessages.get()](#emailmessagesget)
- [EmailMessages.update()](#emailmessagesupdate)
- [EmailMessages.preview()](#emailmessagespreview)
- [EmailMessages.run_guardian()](#emailmessagesrun_guardian)
- [TransactionalGroups.list()](#transactionalgroupslist)
- [TransactionalGroups.create()](#transactionalgroupscreate)
- [TransactionalGroups.get()](#transactionalgroupsget)
- [TransactionalGroups.update()](#transactionalgroupsupdate)
- [Uploads.upload()](#uploadsupload)

---

### ApiKey.test()

Test if your API key is valid.

[API Reference](https://loops.so/docs/api-reference/api-key)

#### Parameters

None

#### Example

```ruby
response LoopsSdk::ApiKey.test
```

#### Response

This method will return a success or error message:

```json
{
  "success": true,
  "teamName": "Company name"
}
```

```json
{
  "error": "Invalid API key"
}
```

---

### Contacts.create()

Create a new contact.

[API Reference](https://loops.so/docs/api-reference/create-contact)

#### Parameters

| Name            | Type   | Required | Notes                                                                                                                                                                                                                                                                                                                                                                                                               |
| --------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `email`         | string | Yes      | If a contact already exists with this email address, an error response will be returned.                                                                                                                                                                                                                                                                                                                            |
| `properties`    | object | No       | An object containing default and any custom properties for your contact.<br />Please [add custom properties](https://loops.so/docs/contacts/properties#custom-contact-properties) in your Loops account before using them with the SDK.<br />Values can be of type `string`, `number`, `nil` (to reset a value), `boolean` or `date` ([see allowed date formats](https://loops.so/docs/contacts/properties#dates)). |
| `mailing_lists` | object | No       | An object of mailing list IDs and boolean subscription statuses.                                                                                                                                                                                                                                                                                                                                                    |

#### Examples

```ruby
response = LoopsSdk::Contacts.create(email: "hello@gmail.com")

contact_properties = {
  firstName: "Bob" /* Default property */,
  favoriteColor: "Red" /* Custom property */,
};
mailing_lists = {
  cm06f5v0e45nf0ml5754o9cix: true,
  cm16k73gq014h0mmj5b6jdi9r: false,
};
response = LoopsSdk::Contacts.create(
  email: "hello@gmail.com",
  properties: contact_properties,
  mailing_lists: mailing_lists
)
```

#### Response

This method will return a success or error message:

```json
{
  "success": true,
  "id": "cll6b3i8901a9jx0oyktl2m4u"
}
```

```json
{
  "success": false,
  "message": "An error message here."
}
```

---

### Contacts.update()

Update a contact. This method will create a contact if one doesn't already exist.

Note: To update a contact's email address, the contact requires a `user_id` value. Then you can make a request with their `user_id` and an updated email address.

[API Reference](https://loops.so/docs/api-reference/update-contact)

#### Parameters

| Name            | Type   | Required | Notes                                                                                                                                                                                                                                                                                                                                                                                                               |
| --------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `email`         | string | No       | The email address of the contact to update. If there is no contact with this email address, a new contact will be created using the email and properties in this request. Required if `user_id` is not present.                                                                                                                                                                                                     |
| `user_id`       | string | No       | The contact's unique user ID. If you use `user_id` without `email`, this value must have already been added to your contact in Loops. Required if `email` is not present.                                                                                                                                                                                                                                           |
| `properties`    | object | No       | An object containing default and any custom properties for your contact.<br />Please [add custom properties](https://loops.so/docs/contacts/properties#custom-contact-properties) in your Loops account before using them with the SDK.<br />Values can be of type `string`, `number`, `nil` (to reset a value), `boolean` or `date` ([see allowed date formats](https://loops.so/docs/contacts/properties#dates)). |
| `mailing_lists` | object | No       | An object of mailing list IDs and boolean subscription statuses.                                                                                                                                                                                                                                                                                                                                                    |

#### Example

```ruby
contact_properties = {
  firstName: "Bob" /* Default property */,
  favoriteColor: "Blue" /* Custom property */,
};
response = LoopsSdk::Contacts.update(
  email: "hello@gmail.com",
  properties: contact_properties
)

# Updating a contact's email address using user_id
response = LoopsSdk::Contacts.update(
  email: "newemail@gmail.com",
  user_id: "1234"
)

# Subscribing a contact to a mailing list
response = LoopsSdk::Contacts.update(
  email: "hello@gmail.com",
  mailing_lists: {
    cm06f5v0e45nf0ml5754o9cix: true,
  }
)
```

#### Response

This method will return a success or error message:

```json
{
  "success": true,
  "id": "cll6b3i8901a9jx0oyktl2m4u"
}
```

```json
{
  "success": false,
  "message": "An error message here."
}
```

---

### Contacts.find()

Find a contact.

[API Reference](https://loops.so/docs/api-reference/find-contact)

#### Parameters

You must use one parameter in the request.

| Name      | Type   | Required | Notes |
| --------- | ------ | -------- | ----- |
| `email`   | string | No       |       |
| `user_id` | string | No       |       |

#### Examples

```ruby
response = LoopsSdk::Contacts.find(email: "hello@gmail.com")

response = LoopsSdk::Contacts.find(user_id: "12345")
```

#### Response

This method will return a list containing a single contact object, which will include all default properties and any custom properties.

If no contact is found, an empty list will be returned.

```json
[
  {
    "id": "cll6b3i8901a9jx0oyktl2m4u",
    "email": "hello@gmail.com",
    "firstName": "Bob",
    "lastName": null,
    "source": "API",
    "subscribed": true,
    "userGroup": "",
    "userId": "12345",
    "mailingLists": {
      "cm06f5v0e45nf0ml5754o9cix": true
    },
    "optInStatus": null,
    "favoriteColor": "Blue" /* Custom property */
  }
]
```

---

### Contacts.delete()

Delete a contact.

[API Reference](https://loops.so/docs/api-reference/delete-contact)

#### Parameters

You must use one parameter in the request.

| Name      | Type   | Required | Notes |
| --------- | ------ | -------- | ----- |
| `email`   | string | No       |       |
| `user_id` | string | No       |       |

#### Example

```ruby
response = LoopsSdk::Contacts.delete(email: "hello@gmail.com")

response = LoopsSdk::Contacts.delete(user_id: "12345")
```

#### Response

This method will return a success or error message:

```json
{
  "success": true,
  "message": "Contact deleted."
}
```

```json
{
  "success": false,
  "message": "An error message here."
}
```

---

### Contacts.check_suppression()

Check if a contact is suppressed.

[API Reference](https://loops.so/docs/api-reference/check-contact-suppression)

#### Parameters

You must use one parameter in the request.

| Name      | Type   | Required | Notes |
| --------- | ------ | -------- | ----- |
| `email`   | string | No       |       |
| `user_id` | string | No       |       |

#### Example

```ruby
response = LoopsSdk::Contacts.check_suppression(email: "hello@gmail.com")

response = LoopsSdk::Contacts.check_suppression(user_id: "12345")
```

#### Response

This method will return the suppression status for a contact and the suppression removal quota.

```json
{
  "contact": {
    "id": "cll6b3i8901a9jx0oyktl2m4u",
    "email": "hello@gmail.com",
    "userId": "12345"
  },
  "isSuppressed": true,
  "removalQuota": {
    "limit": 100,
    "remaining": 4
  }
}
```

```json
{
  "success": false,
  "message": "An email or userId is required."
}
```

---

### Contacts.remove_suppression()

Remove suppression for a contact.

[API Reference](https://loops.so/docs/api-reference/remove-contact-suppression)

#### Parameters

You must use one parameter in the request.

| Name      | Type   | Required | Notes |
| --------- | ------ | -------- | ----- |
| `email`   | string | No       |       |
| `user_id` | string | No       |       |

#### Example

```ruby
response = LoopsSdk::Contacts.remove_suppression(email: "hello@gmail.com")

response = LoopsSdk::Contacts.remove_suppression(user_id: "12345")
```

#### Response

This method will return a success or error message:

```json
{
  "success": true,
  "message": "Email removed from suppression list.",
  "removalQuota": {
    "limit": 100,
    "remaining": 4
  }
}
```

```json
{
  "success": false,
  "message": "This contact is not suppressed."
}
```

---

### ContactProperties.create()

Create a new contact property.

[API Reference](https://loops.so/docs/api-reference/create-contact-property)

#### Parameters

| Name   | Type   | Required | Notes                                                                                  |
| ------ | ------ | -------- | -------------------------------------------------------------------------------------- |
| `name` | string | Yes      | The name of the property. Should be in camelCase, like `planName` or `favouriteColor`. |
| `type` | string | Yes      | The property's value type.<br />Can be one of `string`, `number`, `boolean` or `date`. |

#### Examples

```ruby
response = LoopsSdk::ContactProperties.create(
  name: "planName",
  type: "string"
)
```

#### Response

This method will return a success or error message:

```json
{
  "success": true
}
```

```json
{
  "success": false,
  "message": "An error message here."
}
```

---

### ContactProperties.list()

Get a list of your account's contact properties.

[API Reference](https://loops.so/docs/api-reference/list-contact-properties)

#### Parameters

| Name   | Type   | Required | Notes                                                           |
| ------ | ------ | -------- | --------------------------------------------------------------- |
| `list` | string | No       | Use "custom" to retrieve only your account's custom properties. |

#### Example

```ruby
response = LoopsSdk::ContactProperties.list

response = LoopsSdk::ContactProperties.list(list: "custom")
```

#### Response

This method will return a list of contact property objects containing `key`, `label` and `type` attributes.

```json
[
  {
    "key": "firstName",
    "label": "First Name",
    "type": "string"
  },
  {
    "key": "lastName",
    "label": "Last Name",
    "type": "string"
  },
  {
    "key": "email",
    "label": "Email",
    "type": "string"
  },
  {
    "key": "notes",
    "label": "Notes",
    "type": "string"
  },
  {
    "key": "source",
    "label": "Source",
    "type": "string"
  },
  {
    "key": "userGroup",
    "label": "User Group",
    "type": "string"
  },
  {
    "key": "userId",
    "label": "User Id",
    "type": "string"
  },
  {
    "key": "subscribed",
    "label": "Subscribed",
    "type": "boolean"
  },
  {
    "key": "createdAt",
    "label": "Created At",
    "type": "date"
  },
  {
    "key": "favoriteColor",
    "label": "Favorite Color",
    "type": "string"
  },
  {
    "key": "plan",
    "label": "Plan",
    "type": "string"
  }
]
```

---

### MailingLists.list()

Get a list of your account's mailing lists. [Read more about mailing lists](https://loops.so/docs/contacts/mailing-lists)

[API Reference](https://loops.so/docs/api-reference/list-mailing-lists)

#### Parameters

None

#### Example

```ruby
response = LoopsSdk::MailingLists.list
```

#### Response

This method will return a list of mailing list objects containing `id`, `name`, `description` and `isPublic` attributes.

If your account has no mailing lists, an empty list will be returned.

```json
[
  {
    "id": "cm06f5v0e45nf0ml5754o9cix",
    "name": "Main list",
    "description": "All customers.",
    "isPublic": true
  },
  {
    "id": "cm16k73gq014h0mmj5b6jdi9r",
    "name": "Investors",
    "description": null,
    "isPublic": false
  }
]
```

---

### Events.send()

Send an event to trigger an email in Loops. [Read more about events](https://loops.so/docs/events)

[API Reference](https://loops.so/docs/api-reference/send-event)

#### Parameters

| Name                 | Type   | Required | Notes                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| -------------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `event_name`         | string | Yes      |                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `email`              | string | No       | The contact's email address. Required if `user_id` is not present.                                                                                                                                                                                                                                                                                                                                                                                            |
| `user_id`            | string | No       | The contact's unique user ID. If you use `user_id` without `email`, this value must have already been added to your contact in Loops. Required if `email` is not present.                                                                                                                                                                                                                                                                                     |
| `contact_properties` | object | No       | An object containing contact properties, which will be updated or added to the contact when the event is received.<br />Please [add custom properties](https://loops.so/docs/contacts/properties#custom-contact-properties) in your Loops account before using them with the SDK.<br />Values can be of type `string`, `number`, `nil` (to reset a value), `boolean` or `date` ([see allowed date formats](https://loops.so/docs/contacts/properties#dates)). |
| `event_properties`   | object | No       | An object containing event properties, which will be made available in emails that are triggered by this event.<br />Values can be of type `string`, `number`, `boolean` or `date` ([see allowed date formats](https://loops.so/docs/events/properties#important-information-about-event-properties)).                                                                                                                                                        |
| `mailing_lists`      | object | No       | An object of mailing list IDs and boolean subscription statuses.                                                                                                                                                                                                                                                                                                                                                                                              |
| `headers`            | object | No       | Additional headers to send with the request.                                                                                                                                                                                                                                                                                                                                                                                                                  |

#### Examples

```ruby
response = LoopsSdk::Events.send(
  event_name: "signup",
  email: "hello@gmail.com"
)

response = LoopsSdk::Events.send(
  event_name: "signup",
  email: "hello@gmail.com",
  event_properties: {
    username: "user1234",
    signupDate: "2024-03-21T10:09:23Z",
  },
  mailing_lists: {
    cm06f5v0e45nf0ml5754o9cix: true,
    cm16k73gq014h0mmj5b6jdi9r: false,
  },
)

# In this case with both email and userId present, the system will look for a contact with either a
#  matching `email` or `user_id` value.
# If a contact is found for one of the values (e.g. `email`), the other value (e.g. `user_id`) will be updated.
# If a contact is not found, a new contact will be created using both `email` and `user_id` values.
# Any values added in `contact_properties` will also be updated on the contact.
response = LoopsSdk::Events.send(
  event_name: "signup",
  email: "hello@gmail.com",
  user_id: "1234567890",
  contact_properties: {
    firstName: "Bob",
    plan: "pro",
  },
)

# Example with Idempotency-Key header
response = LoopsSdk::Events.send(
  event_name: "signup",
  email: "hello@gmail.com",
  headers: {
    "Idempotency-Key" => "550e8400-e29b-41d4-a716-446655440000"
  },
)
```

#### Response

This method will return a success or error:

```json
{
  "success": true
}
```

```json
{
  "success": false,
  "message": "An error message here."
}
```

---

### Transactional.list()

List transactional emails, most recently created first.

[API Reference](https://loops.so/docs/api-reference/list-transactional-emails)

#### Parameters

| Name      | Type    | Required | Notes                                                                                                                         |
| --------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `perPage` | integer | No       | How many results to return per page. Must be between 10 and 50. Defaults to 20 if omitted.                                    |
| `cursor`  | string  | No       | A cursor, to return a specific page of results. Cursors can be found from the `pagination.nextCursor` value in each response. |

#### Example

```ruby
response = LoopsSdk::Transactional.list

response = LoopsSdk::Transactional.list(perPage: 15, cursor: "cursor_value")
```

#### Response

```json
{
  "pagination": {
    "totalResults": 23,
    "returnedResults": 20,
    "perPage": 20,
    "totalPages": 2,
    "nextCursor": "clyo0q4wo01p59fsecyxqsh38",
    "nextPage": "https://app.loops.so/api/v1/transactional-emails?cursor=clyo0q4wo01p59fsecyxqsh38&perPage=20"
  },
  "data": [
    {
      "id": "clfn0k1yg001imo0fdeqg30i8",
      "name": "Welcome email",
      "draftEmailMessageId": null,
      "publishedEmailMessageId": "cly8k3m0n0044jpx2bghepq45",
      "createdAt": "2023-11-06T17:48:07.249Z",
      "updatedAt": "2023-11-06T17:48:07.249Z",
      "dataVariables": ["confirmationUrl"]
    }
  ]
}
```

---

### Transactional.create()

Create a transactional email. An empty draft email message is created automatically.

[API Reference](https://loops.so/docs/api-reference/create-transactional-email)

#### Parameters

| Name                     | Type   | Required | Notes                                                   |
| ------------------------ | ------ | -------- | ------------------------------------------------------- |
| `name`                   | string | Yes      |                                                         |
| `transactional_group_id` | string | No       | The ID of the group to add this transactional email to. |

#### Example

```ruby
response = LoopsSdk::Transactional.create(name: "Welcome email")
```

#### Response

Returns the transactional email with `draftEmailMessageId` and `draftEmailMessageContentRevisionId`. Use these when updating the draft via `EmailMessages.update()`.

```json
{
  "id": "clfq6dinn000yl70fgwwyp82l",
  "name": "Welcome email",
  "draftEmailMessageId": "cly8k3m0n0044jpx2bghepq45",
  "draftEmailMessageContentRevisionId": "clm9n4o6p0088lrz4dijslt67",
  "publishedEmailMessageId": null,
  "createdAt": "2023-11-06T17:48:07.249Z",
  "updatedAt": "2023-11-06T17:48:07.249Z",
  "dataVariables": []
}
```

---

### Transactional.get()

Get a single transactional email by ID.

[API Reference](https://loops.so/docs/api-reference/get-transactional-email)

#### Parameters

| Name               | Type   | Required | Notes |
| ------------------ | ------ | -------- | ----- |
| `transactional_id`               | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::Transactional.get(transactional_id: "clfq6dinn000yl70fgwwyp82l")
```

---

### Transactional.update()

Update a transactional email's name.

[API Reference](https://loops.so/docs/api-reference/update-transactional-email)

#### Parameters

| Name                     | Type   | Required | Notes                                                        |
| ------------------------ | ------ | -------- | ------------------------------------------------------------ |
| `transactional_id`                     | string | Yes      |                                                              |
| `name`                   | string | No       |                                                              |
| `transactional_group_id` | string | No       | The ID of the group to move this transactional email to.     |

At least one field must be provided.

#### Example

```ruby
response = LoopsSdk::Transactional.update(
  transactional_id: "clfq6dinn000yl70fgwwyp82l",
  name: "Updated name"
)
```

---

### Transactional.ensure_draft()

Ensure a transactional email has a draft email message. If a draft already exists it is returned unchanged; otherwise a new empty draft is created.

[API Reference](https://loops.so/docs/api-reference/ensure-transactional-email-draft)

#### Parameters

| Name               | Type   | Required | Notes |
| ------------------ | ------ | -------- | ----- |
| `transactional_id`               | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::Transactional.ensure_draft(transactional_id: "clfq6dinn000yl70fgwwyp82l")
```

---

### Transactional.publish()

Publish a transactional email's current draft. The draft becomes the published version and the draft is cleared.

[API Reference](https://loops.so/docs/api-reference/publish-transactional-email)

#### Parameters

| Name               | Type   | Required | Notes |
| ------------------ | ------ | -------- | ----- |
| `transactional_id`               | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::Transactional.publish(transactional_id: "clfq6dinn000yl70fgwwyp82l")
```

---

### Transactional.send()

Send a transactional email to a contact. [Learn about sending transactional email](https://loops.so/docs/transactional/guide)

[API Reference](https://loops.so/docs/api-reference/send-transactional-email)

#### Parameters

| Name                         | Type     | Required | Notes                                                                                                                                                                                            |
| ---------------------------- | -------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `transactional_id`                         | string   | Yes      | The ID of the transactional email to send.                                                                                                                                                       |
| `email`                      | string   | Yes      | The email address of the recipient.                                                                                                                                                              |
| `add_to_audience`            | boolean  | No       | If `true`, a contact will be created in your audience using the `email` value (if a matching contact doesn't already exist).                                                                     |
| `data_variables`             | object   | No       | An object containing data as defined by the data variables added to the transactional email template.<br />Values can be of type `string` or `number`.                                           |
| `attachments`                | object[] | No       | A list of attachments objects.<br />**Please note**: Attachments need to be enabled on your account before using them with the API. [Read more](https://loops.so/docs/transactional/attachments) |
| `attachments[].filename`     | string   | No       | The name of the file, shown in email clients.                                                                                                                                                    |
| `attachments[].content_type` | string   | No       | The MIME type of the file.                                                                                                                                                                       |
| `attachments[].data`         | string   | No       | The base64-encoded content of the file.                                                                                                                                                          |
| `headers`                    | object   | No       | Additional headers to send with the request.                                                                                                                                                     |

#### Examples

```ruby
response = LoopsSdk::Transactional.send(
  transactional_id: "clfq6dinn000yl70fgwwyp82l",
  email: "hello@gmail.com",
  data_variables: {
    loginUrl: "https://myapp.com/login/",
  },
)

# Example with Idempotency-Key header
response = LoopsSdk::Transactional.send(
  transactional_id: "clfq6dinn000yl70fgwwyp82l",
  email: "hello@gmail.com",
  data_variables: {
    loginUrl: "https://myapp.com/login/",
  },
  headers: {
    "Idempotency-Key" => "550e8400-e29b-41d4-a716-446655440000"
  },
)

# Please contact us to enable attachments on your account.
response = LoopsSdk::Transactional.send(
  transactional_id: "clfq6dinn000yl70fgwwyp82l",
  email: "hello@gmail.com",
  data_variables: {
    loginUrl: "https://myapp.com/login/",
  },
  attachments: [
    {
      filename: "presentation.pdf",
      content_type: "application/pdf",
      data: "JVBERi0xLjMKJcTl8uXrp/Og0MTGCjQgMCBvYmoKPD...",
    },
  ],
)
```

#### Response

This method will return a success or error message.

```json
{
  "success": true
}
```

If there is a problem with the request, a descriptive error message will be returned:

```json
{
  "success": false,
  "path": "dataVariables",
  "message": "There are required fields for this email. You need to include a 'dataVariables' object with the required fields."
}
```

```json
{
  "success": false,
  "error": {
    "path": "dataVariables",
    "message": "Missing required fields: login_url"
  },
  "transactionalId": "clfq6dinn000yl70fgwwyp82l"
}
```

---

### DedicatedSendingIps.list()

Get Loops' dedicated sending IP addresses.

[API Reference](https://loops.so/docs/api-reference/list-dedicated-sending-ips)

#### Parameters

None

#### Example

```ruby
response = LoopsSdk::DedicatedSendingIps.list
```

#### Response

Returns an array of IP address strings.

```json
["1.2.3.4", "5.6.7.8"]
```

---

### Themes.list()

List email themes.

[API Reference](https://loops.so/docs/api-reference/list-themes)

#### Parameters

| Name      | Type    | Required | Notes                                                                                                                         |
| --------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `perPage` | integer | No       | How many results to return per page. Must be between 10 and 50. Defaults to 20 if omitted.                                    |
| `cursor`  | string  | No       | A cursor, to return a specific page of results. Cursors can be found from the `pagination.nextCursor` value in each response. |

#### Example

```ruby
response = LoopsSdk::Themes.list

response = LoopsSdk::Themes.list(perPage: 15, cursor: "cursor_value")
```

---

### Themes.get()

Get a single theme by ID.

[API Reference](https://loops.so/docs/api-reference/get-theme)

#### Parameters

| Name       | Type   | Required | Notes |
| ---------- | ------ | -------- | ----- |
| `theme_id`       | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::Themes.get(theme_id: "clo5p8q0r0132ntx6flkunw89")
```

---

### Themes.create()

Create a new email theme.

[API Reference](https://loops.so/docs/api-reference/create-theme)

#### Parameters

| Name     | Type   | Required | Notes                                                                                              |
| -------- | ------ | -------- | -------------------------------------------------------------------------------------------------- |
| `name`   | string | Yes      |                                                                                                    |
| `styles` | object | No       | Style attributes matching LMX `<Style />` tag attribute names. See the API reference for the full list. |

#### Example

```ruby
response = LoopsSdk::Themes.create(
  name: "Dark mode",
  styles: { backgroundColor: "#111827", bodyColor: "#1f2937" }
)
```

---

### Themes.update()

Update a theme's name and/or styles. Style changes cascade to emails using the theme.

[API Reference](https://loops.so/docs/api-reference/update-theme)

#### Parameters

| Name       | Type   | Required | Notes |
| ---------- | ------ | -------- | ----- |
| `theme_id` | string | Yes      |       |
| `name`     | string | No       |       |
| `styles`   | object | No       |       |

At least one of `name` or `styles` must be provided.

#### Example

```ruby
response = LoopsSdk::Themes.update(
  theme_id: "clo5p8q0r0132ntx6flkunw89",
  name: "Updated theme"
)
```

---

### Components.list()

List email components.

[API Reference](https://loops.so/docs/api-reference/list-components)

#### Parameters

| Name      | Type    | Required | Notes                                                                                                                         |
| --------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `perPage` | integer | No       | How many results to return per page. Must be between 10 and 50. Defaults to 20 if omitted.                                    |
| `cursor`  | string  | No       | A cursor, to return a specific page of results. Cursors can be found from the `pagination.nextCursor` value in each response. |

#### Example

```ruby
response = LoopsSdk::Components.list
```

---

### Components.get()

Get a single component by ID.

[API Reference](https://loops.so/docs/api-reference/get-component)

#### Parameters

| Name           | Type   | Required | Notes |
| -------------- | ------ | -------- | ----- |
| `component_id`           | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::Components.get(component_id: "clp6q9r1s0154ouy7gmlovx90")
```

---

### Components.create()

Create a new email component from an LMX body.

[API Reference](https://loops.so/docs/api-reference/create-component)

#### Parameters

| Name   | Type   | Required | Notes                            |
| ------ | ------ | -------- | -------------------------------- |
| `name` | string | Yes      |                                  |
| `lmx`  | string | Yes      | The component body as LMX.       |

#### Example

```ruby
response = LoopsSdk::Components.create(
  name: "Header",
  lmx: "<Paragraph>Welcome to Acme</Paragraph>"
)
```

---

### Components.update()

Update a component's name and/or LMX body. Body changes cascade to emails using the component.

[API Reference](https://loops.so/docs/api-reference/update-component)

#### Parameters

| Name           | Type   | Required | Notes |
| -------------- | ------ | -------- | ----- |
| `component_id` | string | Yes      |       |
| `name`         | string | No       |       |
| `lmx`          | string | No       |       |

At least one of `name` or `lmx` must be provided.

#### Example

```ruby
response = LoopsSdk::Components.update(
  component_id: "clp6q9r1s0154ouy7gmlovx90",
  name: "Updated Header"
)
```

---

### Campaigns.list()

List campaigns.

[API Reference](https://loops.so/docs/api-reference/list-campaigns)

#### Parameters

| Name      | Type    | Required | Notes                                                                                                                         |
| --------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `perPage` | integer | No       | How many results to return per page. Must be between 10 and 50. Defaults to 20 if omitted.                                    |
| `cursor`  | string  | No       | A cursor, to return a specific page of results. Cursors can be found from the `pagination.nextCursor` value in each response. |

#### Example

```ruby
response = LoopsSdk::Campaigns.list
```

---

### Campaigns.create()

Create a draft campaign. An empty email message is created automatically.

[API Reference](https://loops.so/docs/api-reference/create-campaign)

#### Parameters

| Name                   | Type   | Required | Notes                                                                                                 |
| ---------------------- | ------ | -------- | ----------------------------------------------------------------------------------------------------- |
| `name`                 | string | Yes      |                                                                                                       |
| `campaign_group_id`    | string | No       | The ID of the group to add this campaign to.                                                          |
| `mailing_list_id`      | string | No       | The ID of the mailing list to send to.                                                                |
| `audience_segment_id`  | string | No       | The ID of an audience segment. Setting this clears any `audience_filter`.                             |
| `audience_filter`      | object | No       | A tree of audience conditions. See the API reference for the filter schema.                           |
| `scheduling`           | object | No       | When the campaign should send. Use `{ method: "now" }` or `{ method: "schedule", timestamp: "..." }`. |

#### Example

```ruby
response = LoopsSdk::Campaigns.create(name: "Spring announcement")

response = LoopsSdk::Campaigns.create(
  name: "Spring announcement",
  mailing_list_id: "cm06f5v0e45nf0ml5754o9cix",
  scheduling: { method: "schedule", timestamp: "2026-06-01T10:00:00Z" }
)
```

---

### Campaigns.get()

Get a single campaign by ID.

[API Reference](https://loops.so/docs/api-reference/get-campaign)

#### Parameters

| Name          | Type   | Required | Notes |
| ------------- | ------ | -------- | ----- |
| `campaign_id`          | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::Campaigns.get(campaign_id: "cln4o7p9q0110msw5ekjtmv78")
```

---

### Campaigns.update()

Update a draft campaign's name, group, audience, or scheduling.

[API Reference](https://loops.so/docs/api-reference/update-campaign)

#### Parameters

| Name                  | Type   | Required | Notes                                                                                                 |
| --------------------- | ------ | -------- | ----------------------------------------------------------------------------------------------------- |
| `campaign_id`                  | string | Yes      |                                                                                                       |
| `name`                | string | No       |                                                                                                       |
| `campaign_group_id`   | string | No       | The ID of the group to move this campaign to.                                                         |
| `mailing_list_id`     | string | No       | The ID of the mailing list to send to.                                                                |
| `audience_segment_id` | string | No       | The ID of an audience segment. Setting this clears any `audience_filter`.                             |
| `audience_filter`     | object | No       | A tree of audience conditions. See the API reference for the filter schema.                           |
| `scheduling`          | object | No       | When the campaign should send. Use `{ method: "now" }` or `{ method: "schedule", timestamp: "..." }`. |

At least one field must be provided.

#### Example

```ruby
response = LoopsSdk::Campaigns.update(
  campaign_id: "cln4o7p9q0110msw5ekjtmv78",
  name: "Updated campaign name"
)
```

---

### EmailMessages.get()

Get an email message, including its LMX content.

[API Reference](https://loops.so/docs/api-reference/get-email-message)

#### Parameters

| Name                | Type   | Required | Notes |
| ------------------- | ------ | -------- | ----- |
| `email_message_id`                | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::EmailMessages.get(email_message_id: "cly8k3m0n0044jpx2bghepq45")
```

---

### EmailMessages.update()

Update an email message for a draft campaign.

[API Reference](https://loops.so/docs/api-reference/update-email-message)

#### Parameters

| Name                           | Type   | Required | Notes                                                                                                      |
| ------------------------------ | ------ | -------- | ---------------------------------------------------------------------------------------------------------- |
| `email_message_id`                           | string | Yes      |                                                                                                            |
| `expected_revision_id`         | string | No       | The `contentRevisionId` from your last fetch. Required to avoid stale concurrent updates.                  |
| `subject`                      | string | No       |                                                                                                            |
| `preview_text`                 | string | No       |                                                                                                            |
| `from_name`                    | string | No       |                                                                                                            |
| `from_email`                   | string | No       | Sender username without `@` or domain. The team's sending domain is appended automatically.                |
| `reply_to_email`               | string | No       | Must be empty or a valid email address.                                                                    |
| `cc_email`                     | string | No       | CC email address. Requires the team to have CC/BCC enabled.                                                |
| `bcc_email`                    | string | No       | BCC email address. Requires the team to have CC/BCC enabled.                                               |
| `language_code`                | string | No       | Language code for the email. Requires translation to be enabled for the team.                              |
| `email_format`                 | string | No       | The rendering format of the email. One of `styled` or `plain`.                                             |
| `lmx`                          | string | No       | Email body serialized as LMX. Styles must be embedded in the LMX `<Style />` tag.                          |
| `contact_properties_fallbacks` | object | No       | Fallback values for contact properties. A null value deletes the fallback.                                 |
| `event_properties_fallbacks`   | object | No       | Fallback values for event properties. A null value deletes the fallback.                                   |
| `data_variables_fallbacks`     | object | No       | Fallback values for data variables. A null value deletes the fallback.                                     |

#### Example

```ruby
response = LoopsSdk::EmailMessages.update(
  email_message_id: "cly8k3m0n0044jpx2bghepq45",
  expected_revision_id: "clm9n4o6p0088lrz4dijslt67",
  subject: "Spring announcement",
  preview_text: "See what's new",
  from_name: "Loops",
  from_email: "hello",
  lmx: "<Email><Style /></Email>"
)
```

---

### EmailMessages.preview()

Send a test preview of an email message to one or more addresses.

[API Reference](https://loops.so/docs/api-reference/preview-email-message)

#### Parameters

| Name                 | Type     | Required | Notes                                                                             |
| -------------------- | -------- | -------- | --------------------------------------------------------------------------------- |
| `email_message_id`                 | string   | Yes      |                                                                                   |
| `emails`             | string[] | Yes      | One or more addresses to send the preview to.                                     |
| `contact_properties` | object   | No       | Contact property values to render. Accepted for campaign and workflow previews.   |
| `event_properties`   | object   | No       | Event property values to render. Accepted for workflow previews only.             |
| `data_variables`     | object   | No       | Transactional data variables to render. Accepted for transactional previews only. |

#### Example

```ruby
response = LoopsSdk::EmailMessages.preview(
  email_message_id: "cly8k3m0n0044jpx2bghepq45",
  emails: ["test@example.com"],
  contact_properties: { firstName: "Alex" }
)
```

---

### EmailMessages.run_guardian()

Run Guardian content validation on an email message and return errors and warnings.

[API Reference](https://loops.so/docs/api-reference/run-guardian-checks)

#### Parameters

| Name               | Type   | Required | Notes |
| ------------------ | ------ | -------- | ----- |
| `email_message_id` | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::EmailMessages.run_guardian(email_message_id: "cly8k3m0n0044jpx2bghepq45")
```

#### Response

```json
{
  "errors": [],
  "warnings": []
}
```

---

### CampaignGroups.list()

List campaign groups.

[API Reference](https://loops.so/docs/api-reference/list-campaign-groups)

#### Parameters

| Name      | Type    | Required | Notes                                                                                                                         |
| --------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `perPage` | integer | No       | How many results to return per page. Must be between 10 and 50. Defaults to 20 if omitted.                                    |
| `cursor`  | string  | No       | A cursor, to return a specific page of results. Cursors can be found from the `pagination.nextCursor` value in each response. |

#### Example

```ruby
response = LoopsSdk::CampaignGroups.list
```

---

### CampaignGroups.create()

Create a campaign group.

[API Reference](https://loops.so/docs/api-reference/create-campaign-group)

#### Parameters

| Name          | Type   | Required | Notes                                   |
| ------------- | ------ | -------- | --------------------------------------- |
| `name`        | string | Yes      | Cannot be the reserved name "Unsorted". |
| `description` | string | No       | An optional description for the group.  |

#### Example

```ruby
response = LoopsSdk::CampaignGroups.create(name: "Newsletters", description: "Monthly updates")
```

---

### CampaignGroups.get()

Get a campaign group by ID.

[API Reference](https://loops.so/docs/api-reference/get-campaign-group)

#### Parameters

| Name | Type   | Required | Notes |
| ---- | ------ | -------- | ----- |
| `campaign_group_id` | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::CampaignGroups.get(campaign_group_id: "clq7r0s2t0176pvz8hnmpwy01")
```

---

### CampaignGroups.update()

Update a campaign group's name or description.

[API Reference](https://loops.so/docs/api-reference/update-campaign-group)

#### Parameters

| Name          | Type   | Required | Notes                                   |
| ------------- | ------ | -------- | --------------------------------------- |
| `campaign_group_id`          | string | Yes      |                                         |
| `name`        | string | No       | Cannot be the reserved name "Unsorted". |
| `description` | string | No       |                                         |

At least one field must be provided.

#### Example

```ruby
response = LoopsSdk::CampaignGroups.update(
  campaign_group_id: "clq7r0s2t0176pvz8hnmpwy01",
  name: "Updated name"
)
```

---

### AudienceSegments.list()

List audience segments.

[API Reference](https://loops.so/docs/api-reference/list-audience-segments)

#### Parameters

| Name      | Type    | Required | Notes                                                                                                                         |
| --------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `perPage` | integer | No       | How many results to return per page. Must be between 10 and 50. Defaults to 20 if omitted.                                    |
| `cursor`  | string  | No       | A cursor, to return a specific page of results. Cursors can be found from the `pagination.nextCursor` value in each response. |

#### Example

```ruby
response = LoopsSdk::AudienceSegments.list
```

---

### AudienceSegments.get()

Get an audience segment by ID.

[API Reference](https://loops.so/docs/api-reference/get-audience-segment)

#### Parameters

| Name | Type   | Required | Notes |
| ---- | ------ | -------- | ----- |
| `audience_segment_id` | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::AudienceSegments.get(audience_segment_id: "clr8s1t3u0198qw09iotqzx12")
```

---

### AudienceSegments.create()

Create a new audience segment.

[API Reference](https://loops.so/docs/api-reference/create-audience-segment)

#### Parameters

| Name          | Type   | Required | Notes                                                                       |
| ------------- | ------ | -------- | --------------------------------------------------------------------------- |
| `name`        | string | Yes      | Must be unique within the team.                                             |
| `filter`      | object | Yes      | JSON tree of audience conditions with `match` and `conditions`. See the [API reference](https://loops.so/docs/api-reference/create-audience-segment#body-filter). |
| `description` | string | No       |                                                                             |

#### Example

```ruby
response = LoopsSdk::AudienceSegments.create(
  name: "Power users",
  filter: {
    match: "all",
    conditions: [
      { type: "property", key: "plan", operator: "equals", value: "pro" }
    ]
  }
)
```

---

### Workflows.list()

List workflows.

[API Reference](https://loops.so/docs/api-reference/list-workflows)

#### Parameters

| Name      | Type    | Required | Notes                                                                                                                         |
| --------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `perPage` | integer | No       | How many results to return per page. Must be between 10 and 50. Defaults to 20 if omitted.                                    |
| `cursor`  | string  | No       | A cursor, to return a specific page of results. Cursors can be found from the `pagination.nextCursor` value in each response. |

#### Example

```ruby
response = LoopsSdk::Workflows.list
```

---

### Workflows.create()

Create a draft workflow with a blank trigger and exit node.

[API Reference](https://loops.so/docs/api-reference/create-workflow)

#### Parameters

| Name              | Type   | Required | Notes                                          |
| ----------------- | ------ | -------- | ---------------------------------------------- |
| `name`            | string | Yes      |                                                |
| `description`     | string | No       |                                                |
| `mailing_list_id` | string | No       | The mailing list the workflow sends to.        |

#### Example

```ruby
response = LoopsSdk::Workflows.create(name: "Welcome series")
```

---

### Workflows.get()

Get a simplified workflow graph.

[API Reference](https://loops.so/docs/api-reference/get-workflow)

#### Parameters

| Name | Type   | Required | Notes |
| ---- | ------ | -------- | ----- |
| `workflow_id` | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::Workflows.get(workflow_id: "cls9t2u4v0210rx20jpuary23")
```

---

### Workflows.update()

Update a workflow's display properties. To change the mailing list, use `Workflows.change_mailing_list()`.

[API Reference](https://loops.so/docs/api-reference/update-workflow)

#### Parameters

| Name                     | Type   | Required | Notes                                                                                          |
| ------------------------ | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| `workflow_id`            | string | Yes      |                                                                                                |
| `expected_revision_id`   | string | Yes      | The `workflowRevisionId` from the latest read or mutation. Pass `nil` for older workflows.     |
| `name`                   | string | No       |                                                                                                |
| `description`            | string | No       |                                                                                                |

At least one of `name` or `description` must be provided.

#### Example

```ruby
response = LoopsSdk::Workflows.update(
  workflow_id: "cls9t2u4v0210rx20jpuary23",
  expected_revision_id: "rev_123",
  name: "Updated name"
)
```

---

### Workflows.change_mailing_list()

Dry run or apply a workflow mailing list change. If queued contacts would be removed, the API returns `"status": "queuedContactsFound"` — retry with `queued_contact_policy: "discard"` to apply.

[API Reference](https://loops.so/docs/api-reference/change-workflow-mailing-list)

#### Parameters

| Name                     | Type    | Required | Notes                                                                 |
| ------------------------ | ------- | -------- | --------------------------------------------------------------------- |
| `workflow_id`            | string  | Yes      |                                                                       |
| `expected_revision_id`   | string  | Yes      | Pass `nil` for older workflows.                                       |
| `mailing_list_id`        | string  | Yes      | Pass `nil` to clear the mailing list.                                 |
| `dry_run`                | boolean | No       | If `true`, validate without modifying.                                |
| `queued_contact_policy`  | string  | No       | `fail` (default) or `discard`.                                        |

#### Example

```ruby
response = LoopsSdk::Workflows.change_mailing_list(
  workflow_id: "cls9t2u4v0210rx20jpuary23",
  expected_revision_id: "rev_123",
  mailing_list_id: "cm06f5v0e45nf0ml5754o9cix",
  dry_run: true
)
```

---

### Workflows.get_node()

Get detailed data for a single workflow node.

[API Reference](https://loops.so/docs/api-reference/get-workflow-node)

#### Parameters

| Name         | Type   | Required | Notes |
| ------------ | ------ | -------- | ----- |
| `workflow_id`| string | Yes      |       |
| `node_id`    | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::Workflows.get_node(workflow_id: "cls9t2u4v0210rx20jpuary23", node_id: "clt0u3v5w0232sy31kqvbzs34")
```

---

### Workflows.create_node()

Create a new default workflow node. Use `insert_mode: "between"` with `from_node_id`/`to_node_id`, or `insert_mode: "before"` with `before_node_id`.

[API Reference](https://loops.so/docs/api-reference/create-workflow-node)

#### Parameters

| Name                   | Type   | Required | Notes                                                                                          |
| ---------------------- | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| `workflow_id`          | string | Yes      |                                                                                                |
| `expected_revision_id` | string | Yes      | Pass `nil` for older workflows.                                                                |
| `insert_mode`          | string | Yes      | `between` or `before`.                                                                         |
| `node_type_name`       | string | Yes      | One of `AudienceFilter`, `BranchNode`, `ExperimentBranchNode`, `TimerAction`, `SendEmailAction`, `VariantNode`. |
| `from_node_id`         | string | No       | Required when `insert_mode` is `between`.                                                      |
| `to_node_id`           | string | No       | Required when `insert_mode` is `between`.                                                      |
| `before_node_id`       | string | No       | Required when `insert_mode` is `before`.                                                       |

#### Example

```ruby
response = LoopsSdk::Workflows.create_node(
  workflow_id: "cls9t2u4v0210rx20jpuary23",
  expected_revision_id: "rev_123",
  insert_mode: "between",
  node_type_name: "TimerAction",
  from_node_id: "node_a",
  to_node_id: "node_b"
)
```

---

### Workflows.update_node()

Update workflow-node-owned fields for a single node.

[API Reference](https://loops.so/docs/api-reference/update-workflow-node)

#### Parameters

| Name                   | Type   | Required | Notes                                                      |
| ---------------------- | ------ | -------- | ---------------------------------------------------------- |
| `workflow_id`          | string | Yes      |                                                            |
| `node_id`              | string | Yes      |                                                            |
| `expected_revision_id` | string | Yes      | Pass `nil` for older workflows.                            |
| `payload`              | object | Yes      | Node-type-specific fields. See the API reference.          |

#### Example

```ruby
response = LoopsSdk::Workflows.update_node(
  workflow_id: "cls9t2u4v0210rx20jpuary23",
  node_id: "clt0u3v5w0232sy31kqvbzs34",
  expected_revision_id: "rev_123",
  payload: { amount: 2, unit: "d" }
)
```

---

### Workflows.delete_node()

Delete a single workflow node. If contacts are queued, the API returns `"status": "queuedContactsFound"` — retry with `queued_contact_policy: "discard"` to delete.

[API Reference](https://loops.so/docs/api-reference/delete-workflow-node)

#### Parameters

| Name                    | Type    | Required | Notes                          |
| ----------------------- | ------- | -------- | ------------------------------ |
| `workflow_id`           | string  | Yes      |                                |
| `node_id`               | string  | Yes      |                                |
| `expected_revision_id`  | string  | Yes      | Pass `nil` for older workflows.|
| `dry_run`               | boolean | No       |                                |
| `queued_contact_policy` | string  | No       | `fail` (default) or `discard`. |

#### Example

```ruby
response = LoopsSdk::Workflows.delete_node(
  workflow_id: "cls9t2u4v0210rx20jpuary23",
  node_id: "clt0u3v5w0232sy31kqvbzs34",
  expected_revision_id: "rev_123",
  dry_run: true
)
```

---

### Workflows.add_branch()

Add a branch and child node under an existing `BranchNode` or `ExperimentBranchNode`.

[API Reference](https://loops.so/docs/api-reference/add-workflow-branch)

#### Parameters

| Name                   | Type   | Required | Notes                           |
| ---------------------- | ------ | -------- | ------------------------------- |
| `workflow_id`          | string | Yes      |                                 |
| `node_id`              | string | Yes      | The branch or experiment node.  |
| `expected_revision_id` | string | Yes      | Pass `nil` for older workflows. |

#### Example

```ruby
response = LoopsSdk::Workflows.add_branch(
  workflow_id: "cls9t2u4v0210rx20jpuary23",
  node_id: "clt0u3v5w0232sy31kqvbzs34",
  expected_revision_id: "rev_123"
)
```

---

### Workflows.delete_node_recursive()

Delete a node and its downstream subtree.

[API Reference](https://loops.so/docs/api-reference/delete-workflow-nodes)

#### Parameters

| Name                    | Type    | Required | Notes                          |
| ----------------------- | ------- | -------- | ------------------------------ |
| `workflow_id`           | string  | Yes      |                                |
| `node_id`               | string  | Yes      | Root of the subtree to delete. |
| `expected_revision_id`  | string  | Yes      | Pass `nil` for older workflows.|
| `dry_run`               | boolean | No       |                                |
| `queued_contact_policy` | string  | No       | `fail` (default) or `discard`. |

#### Example

```ruby
response = LoopsSdk::Workflows.delete_node_recursive(
  workflow_id: "cls9t2u4v0210rx20jpuary23",
  node_id: "clt0u3v5w0232sy31kqvbzs34",
  expected_revision_id: "rev_123",
  queued_contact_policy: "discard"
)
```

---

### EventPatterns.list()

List event patterns available to workflow event trigger nodes.

[API Reference](https://loops.so/docs/api-reference/list-event-patterns)

#### Parameters

| Name      | Type    | Required | Notes                                                                                                                         |
| --------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `perPage` | integer | No       | How many results to return per page. Must be between 10 and 50. Defaults to 20 if omitted.                                    |
| `cursor`  | string  | No       | A cursor, to return a specific page of results. Cursors can be found from the `pagination.nextCursor` value in each response. |

#### Example

```ruby
response = LoopsSdk::EventPatterns.list
```

---

### EventPatterns.get()

Get an event pattern by ID.

[API Reference](https://loops.so/docs/api-reference/get-event-pattern)

#### Parameters

| Name               | Type   | Required | Notes |
| ------------------ | ------ | -------- | ----- |
| `event_pattern_id` | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::EventPatterns.get(event_pattern_id: "cle1v2e3n4t5p6a7t8t9e0r1")
```

---

### EventPatterns.get_by_name()

Get an event pattern by event name. Event names are case-sensitive.

[API Reference](https://loops.so/docs/api-reference/get-event-pattern-by-name)

#### Parameters

| Name         | Type   | Required | Notes |
| ------------ | ------ | -------- | ----- |
| `event_name` | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::EventPatterns.get_by_name(event_name: "signup")
```

---

### TransactionalGroups.list()

List transactional groups.

[API Reference](https://loops.so/docs/api-reference/list-transactional-groups)

#### Parameters

| Name      | Type    | Required | Notes                                                                                                                         |
| --------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `perPage` | integer | No       | How many results to return per page. Must be between 10 and 50. Defaults to 20 if omitted.                                    |
| `cursor`  | string  | No       | A cursor, to return a specific page of results. Cursors can be found from the `pagination.nextCursor` value in each response. |

#### Example

```ruby
response = LoopsSdk::TransactionalGroups.list
```

---

### TransactionalGroups.create()

Create a transactional group.

[API Reference](https://loops.so/docs/api-reference/create-transactional-group)

#### Parameters

| Name          | Type   | Required | Notes                                   |
| ------------- | ------ | -------- | --------------------------------------- |
| `name`        | string | Yes      | Cannot be the reserved name "Unsorted". |
| `description` | string | No       | An optional description for the group.  |

#### Example

```ruby
response = LoopsSdk::TransactionalGroups.create(name: "Account emails")
```

---

### TransactionalGroups.get()

Get a transactional group by ID.

[API Reference](https://loops.so/docs/api-reference/get-transactional-group)

#### Parameters

| Name | Type   | Required | Notes |
| ---- | ------ | -------- | ----- |
| `transactional_group_id` | string | Yes      |       |

#### Example

```ruby
response = LoopsSdk::TransactionalGroups.get(transactional_group_id: "clv2w3x4y0288xbb0kqrsuv67")
```

---

### TransactionalGroups.update()

Update a transactional group's name or description.

[API Reference](https://loops.so/docs/api-reference/update-transactional-group)

#### Parameters

| Name          | Type   | Required | Notes                                   |
| ------------- | ------ | -------- | --------------------------------------- |
| `transactional_group_id`          | string | Yes      |                                         |
| `name`        | string | No       | Cannot be the reserved name "Unsorted". |
| `description` | string | No       |                                         |

At least one field must be provided.

#### Example

```ruby
response = LoopsSdk::TransactionalGroups.update(
  transactional_group_id: "clv2w3x4y0288xbb0kqrsuv67",
  name: "Updated name"
)
```

---

### Uploads.upload()

Upload an image file for use in LMX email content.

Supported image types: JPEG, PNG, GIF, and WebP (max 4 MB). MIME type is detected from file contents, or pass `content_type:` to override.

[API Reference](https://loops.so/docs/api-reference/create-upload)

#### Parameters

| Name            | Type   | Required | Notes                                                                                        |
| --------------- | ------ | -------- | -------------------------------------------------------------------------------------------- |
| `path`          | string | Yes      | Path to the image file on disk.                                                              |
| `content_type`  | string | No       | MIME type override. Supported: `image/jpeg`, `image/png`, `image/gif`, `image/webp`.         |

#### Example

```ruby
response = LoopsSdk::Uploads.upload(path: "./header.png")

# Use the returned URL in LMX
lmx = %(<Image src="#{response['finalUrl']}" alt="Header" />)
```

#### Response

```json
{
  "emailAssetId": "clu1v4w6x0254tz42lrcwat45",
  "finalUrl": "https://cdn.loops.so/clu1v4w6x0254tz42lrcwat45.png"
}
```

---

## Testing

Run tests with `bundle exec rspec`.

---

## Contributing

Bug reports and pull requests are welcome. Please read our [Contributing Guidelines](CONTRIBUTING.md).