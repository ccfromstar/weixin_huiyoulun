// Generated by CoffeeScript 1.8.0
(function() {
  var PageAction, express, router;

  express = require("express");

  router = express.Router();

  PageAction = require("./../action/pageAction");

  router.post("/dologin", PageAction.doLogin);

  router.post("/dounbind", PageAction.doUnbind);

  router.post("/doSetting", PageAction.doSetting);

  router.post("/resetOption", PageAction.resetOption);

  router.get("/", PageAction.weixinLogin, PageAction.index);

  router.get("/login", PageAction.login);

  router.get("/unbind", PageAction.unbind);

  router.get("/setting", PageAction.setting);

  router.get("/search", PageAction.search);

  router.post("/searchResult", PageAction.searchReults);

  router.post("/sendMsg", PageAction.sendMsg);

  router.get("/detail/:pid", PageAction.weixinLogin, PageAction.detail);

  router.get("/priceDetail/:pid", PageAction.weixinLogin, PageAction.priceDetail);

  module.exports = router;

}).call(this);
