
Zoho CRM rest api wrapper for node.js

[![Build Status](https://travis-ci.org/picatic/node-zoho.png?branch=master)](https://travis-ci.org/picatic/node-zoho)
[![NPM version](https://badge.fury.io/js/node-zoho.png)](http://badge.fury.io/js/node-zoho)
[![Code Climate](https://codeclimate.com/github/picatic/node-zoho.png)](https://codeclimate.com/github/picatic/node-zoho)
[![Stories in Ready](https://badge.waffle.io/picatic/node-zoho.png?label=ready&title=Ready)](https://waffle.io/picatic/node-zoho)

currently supports:
 - authentication
 - insertingRecord on all resources

Currently a WIP, but feel free to ask how you can help.

## Product and Module Support

### CRM

<table>
  <header>
    <tr>
      <th>Method</th>
      <th>Leads</th>
      <th>Accounts</th>
      <th>Contacts</th>
      <th>Potentials</th>
      <th>Events</th>
      <th>Notes</th>
    </tr>
  </header>
  <body>
<tr>
  <td>insertRecords</td>
  <td>✓</td>
  <td></td>
  <td></td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
</tr>
<tr>
  <td>convertLead</td>
  <td>✓</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
</tr>
<tr>
  <td>getRecordById</td>
  <td>✓</td>
  <td></td>
  <td></td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
</tr>
<tr>
  <td>getMyRecords</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>getRecords</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
</tr>
<tr>
  <td>getCVRecords</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>updateRecords</td>
  <td>✓</td>
  <td></td>
  <td></td>
  <td>✓</td>
  <td>✓</td>
  <td></td>
</tr>
<tr>
  <td>searchRecords</td>
  <td>✓</td>
  <td></td>
  <td></td>
  <td>✓</td>
  <td>✓</td>
  <td></td>
</tr>
<tr>
  <td>getSearchRecords</td>
  <td>✓</td>
  <td></td>
  <td></td>
  <td>✓</td>
  <td>✓</td>
  <td></td>
</tr>
<tr>
  <td>getSearchRecordsByPDC</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>deleteRecords</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>getRelatedRecords</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>getFields</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td></td>
</tr>
<tr>
  <td>updateRelatedRecords</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>getUsers</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>uploadFile</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>downloadFile</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>deleteFile</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>uploadPhoto</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>downloadPhoto</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>deletePhoto</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
</body>
</table>

More to come...


# Example of use

```
var Zoho = require('node-zoho');

zoho = new Zoho({authToken:'API-TOKEN'});
records = [
  {
    "Lead Source" : "Site Registration",
    "First Name"  : "Test",
    "Last Name"   : "Testerson",
    "Email"       : "test@testerson.com",
  }
];

zoho.execute('crm', 'Leads', 'insertRecords', records, function (err, result) {
  if (err !== null) {
    console.log(err);
  } else if (result.isError()) {
    console.log(result.message);
  } else {
    console.log(result.data);
  }
});
```

# Contribute

All the code is coffescript, but we deploy compiled js to npm. If you want to help, checkout the git repo and submit a PR.

# Release instructions

1. Wait for TravisCI confirmation that latest merge passes tests.
2. Run `grunt bump`. This bumps the package.json version, tags this version and pushes it.
3. `npm publish` will compile the CoffeeScript and push the latest version to npmjs.org

[![NPM](https://nodei.co/npm/node-zoho.png?downloads=true)](https://nodei.co/npm/node-zoho/)

[Zoho CRM API](http://www.zoho.com/crm/help/api/api-methods.html)
