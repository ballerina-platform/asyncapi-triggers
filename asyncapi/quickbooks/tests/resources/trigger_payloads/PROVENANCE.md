# Test fixture provenance

These fixtures share the CloudEvents envelope shape confirmed against Intuit's own
official sample app (IntuitDeveloper/SampleApp-Webhooks-Java-Cloudevents) and a real
captured webhook delivery. Confirmation status varies by field:

- Envelope shape (specversion/id/source/type/datacontenttype/time/intuitentityid/
  intuitaccountid) - confirmed real for every fixture.
- `qbo.customer.created.v1` - every field is the verbatim value from Intuit's
  published sample, not synthetic.
- `data` content on `created` operations - confirmed empty (`{}`), matching the
  real sample.
- `data` content on `merged` operations - confirmed to contain `deletedId`
  (matches a real captured delivery), but the exact ID value here is synthetic.
- `data` content on `updated`/`deleted`/`void`/`emailed` operations - **not yet
  confirmed against a real delivery**. These fixtures use an empty object as a
  placeholder, consistent with the `created` shape, not because it's verified for
  these operations specifically. Replace with real captures as they become available
  (see the plan's step on capturing more real deliveries).
- All `id`/`source`/`time`/`intuitentityid`/`intuitaccountid` values outside the
  one real sample above are synthetic test data, not sourced from real traffic.
