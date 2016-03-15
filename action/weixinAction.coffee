WeixinCtrl = require "./../ctrl/weixinCtrl"

exports.check = (req,res) ->
  signature = req.query.signature
  timestamp = req.query.timestamp
  nonce = req.query.nonce
  echostr = req.query.echostr

  if WeixinCtrl.check timestamp,nonce,signature
    res.send echostr
  else
    res.end()

exports.msg = (req,res) ->
  signature = req.query.signature
  timestamp = req.query.timestamp
  nonce = req.query.nonce
  res.send ""
