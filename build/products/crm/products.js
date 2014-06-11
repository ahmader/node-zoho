// Generated by CoffeeScript 1.7.1
var CrmModule, Products, Request, xml2js, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

_ = require('underscore');

xml2js = require("xml2js");

CrmModule = require('./crm-module');

Request = require('../../request');

Products = (function(_super) {
  __extends(Products, _super);

  function Products() {
    return Products.__super__.constructor.apply(this, arguments);
  }

  Products.prototype.name = 'Products';

  Products.prototype.getMyRecords = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.getRecords = function(_query, cb) {
    throw new Error('Not Implemented');
  };

  Products.prototype.updateRecords = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.getSearchRecords = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.getSearchRecordsByPDC = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.deleteRecords = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.getRelatedRecords = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.getFields = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.updateRelatedRecords = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.getUsers = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.uploadFile = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.downloadFile = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.deleteFile = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.uploadPhoto = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.downloadPhoto = function() {
    throw new Error('Not Implemented');
  };

  Products.prototype.deletePhoto = function() {
    throw new Error('Not Implemented');
  };

  return Products;

})(CrmModule);

module.exports = Products;
