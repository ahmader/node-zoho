
Zoho CRM API REST wrapper for node.js

[![Build Status](https://travis-ci.org/ahmader/node-zoho.png?branch=master)](https://travis-ci.org/ahmader/node-zoho)
[![NPM version](https://badge.fury.io/js/node-zoho.png)](http://badge.fury.io/js/node-zoho)
[![Code Climate](https://codeclimate.com/github/ahmader/node-zoho.png)](https://codeclimate.com/github/ahmader/node-zoho)
[![Stories in Ready](https://badge.waffle.io/ahmader/node-zoho.png?label=ready&title=Ready)](https://waffle.io/ahmader/node-zoho)

Supports:
 - [Zoho CRM API Version 1.0 (EOL)](http://www.zoho.com/crm/help/api/api-methods.html)

Currently a WIP, but feel free to ask how you can help.

## CRM Modules Support:

<table>
  <header>
    <tr>
      <th>Method Name</th>
      <th>Leads</th>
      <th>Accounts</th>
      <th>Contacts</th>
      <th>Potentials</th>
      <th>Events</th>
      <th>Tasks</th>
      <th>Notes</th>
    </tr>
  </header>
  <body>
<tr>
  <td>insertRecords</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
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
  <td>NA</td>
</tr>
<tr>
  <td>getRecordById</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>NA</td>
</tr>
<tr>
  <td>getDeletedRecordIds</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td>NA</td>
</tr>
<tr>
  <td>getMyRecords</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>NA</td>
</tr>
<tr>
  <td>getRecords</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>NA</td>
</tr>
<tr>
  <td>updateRecords</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>NA</td>
</tr>
<tr>
  <td>searchRecords</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>NA</td>
</tr>
<tr>
  <td>getSearchRecords</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>NA</td>
</tr>
<tr>
  <td>getSearchRecordsByPDC</td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td>NA</td>
</tr>
<tr>
  <td>deleteRecords</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
</tr>
<tr>
  <td>getRelatedRecords</td>
  <td></td>
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
  <td>✓</td>
  <td>✓</td>
</tr>
<tr>
  <td>updateRelatedRecords</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
</tr>
<tr>
  <td>uploadFile</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>NA</td>
</tr>
<tr>
  <td>downloadFile</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>NA</td>
</tr>
<tr>
  <td>deleteFile</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>✓</td>
  <td>NA</td>
</tr>
<tr>
  <td>uploadPhoto</td>
  <td>✓</td>
  <td>NA</td>
  <td>✓</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
</tr>
<tr>
  <td>downloadPhoto</td>
  <td></td>
  <td>NA</td>
  <td></td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
</tr>
<tr>
  <td>deletePhoto</td>
  <td></td>
  <td>NA</td>
  <td></td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
</tr>
<tr>
  <td>delink</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
</tr>
<tr>
  <td>getUsers</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
</tr>
<tr>
  <td>getModules</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
  <td>NA</td>
</tr>
</body>
</table>


# Example of use

```
var Zoho = require('node-zoho');

var config = {
    authToken: 'API-TOKEN',
//    region: 'eu',//default is 'com'
};

var zoho = new Zoho(config);
var records = [
  {
    "Lead Source" : "Site Registration",
    "First Name"  : "Test",
    "Last Name"   : "Testerson",
    "Email"       : "test@testerson.com",
  }
];

zoho.execute('crm', 'Leads', 'insertRecords', records, callback);

// to pass optional parameters
zoho.execute('crm', 'Leads', 'insertRecords', records, {wfTrigger: true}, callback);

var callback = function (err, result) {
  if (err !== null) {
    console.log(err);
  } else if (result.isError()) {
    console.log(result.message);
  } else {
    console.log(result.data);
  }
}

```

# Possible Zoho config parameters

<table>
  <header>
    <tr>
      <th>Parameter Name</th>
      <th>Descripion</th>
      <th>Default value</th>
    </tr>
  </header>
  <body>
    <tr>
      <td>authToken</td>
      <td>Your CRM user authtoken</td>
      <td></td>
    </tr>
    <tr>
      <td>region</td>
      <td>Zoho CRM region. Possible values: 'com', 'eu'</td>
      <td>com</td>
    </tr>
  </body>
</table>

# Contribute

All the code is coffescript, but we deploy compiled js to npm. If you want to help, checkout the git repo and submit a PR.

# Release instructions

1. Wait for TravisCI confirmation that latest merge passes tests.
2. Run `grunt release`. This bumps the package.json version, creates npm-shrinkwrap.json, tags this version and pushes it.
3. `npm publish` will compile the CoffeeScript and push the latest version to npmjs.org

[![NPM](https://nodei.co/npm/node-zoho.png?downloads=true)](https://nodei.co/npm/node-zoho/)

[Zoho CRM API Version 1.0 (EOL)](http://www.zoho.com/crm/help/api/api-methods.html)
