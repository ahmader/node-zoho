Zoho CRM rest api wrapper for node.js

[![Build Status](https://travis-ci.org/picatic/node-zoho.png?branch=master)](https://travis-ci.org/picatic/node-zoho)
[![Code Climate](https://codeclimate.com/github/picatic/node-zoho.png)](https://codeclimate.com/github/picatic/node-zoho)

currently supports:
 - authentication
 - insertingRecord on all resources

Currently a WIP, but feel free to ask how you can help.

More to come...


# Example of use

```
var Zoho = require('node-zoho');

zoho = new Zoho({authtoken:'YOUR-API-KEY'});
records = [
  {
    "Lead Source" : "Site Registration"
    "First Name"  : "Test"
    "Last Name"   : "Testerson"
    "Email"       : "test@testerson.com"
  }
];
zoho.execute('crm','Leads','insertRecords',records, function(err, result) {
  if ( result.isError() ) {
    console.log(result.message);
  } else {
    console.log(result.data);
  }
})
```

# Contribute

All the code is coffescript, but we deploy compiled js to npm. If you want to help, checkout the git repo and submit a PR.
