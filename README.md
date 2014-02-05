Zoho CRM rest api wrapper for node.js

[![Build Status](https://travis-ci.org/picatic/node-zoho.png?branch=master)](https://travis-ci.org/picatic/node-zoho)
[![NPM version](https://badge.fury.io/js/node-zoho.png)](http://badge.fury.io/js/node-zoho)

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
    </tr>
  </header>
  <body>
<tr>
  <td>insertRecords</td>
  <td>✓</td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>convertLead</td>
  <td>✓</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
</tr>
<tr>
  <td>getRecordById</td>
  <td>✓</td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>getMyRecords</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>getRecords</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>getCVRecords</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>updateRecords</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>getSearchRecords</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>getSearchRecordsByPDC</td>
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
</tr>
<tr>
  <td>getRelatedRecords</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>getFields</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
</tr>
<tr>
  <td>updateRelatedRecords</td>
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
</tr>
<tr>
  <td>uploadFile</td>
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
</tr>
<tr>
  <td>deleteFile</td>
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
</tr>
<tr>
  <td>downloadPhoto</td>
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

[![NPM](https://nodei.co/npm/node-zoho.png?downloads=true)](https://nodei.co/npm/node-zoho/)
