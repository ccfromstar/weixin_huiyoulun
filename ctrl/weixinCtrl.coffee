config = require "./../config/weixin.json"
request = require "request"
crypto = require "crypto"
async = require "async"
class WeixinCtrl
  @check:(timestamp,nonce,signature) ->
    tmp = [config.token, timestamp, nonce].sort().join("")
    currSign = crypto.createHash("sha1").update(tmp).digest("hex")
    currSign is signature

  @accessToken:(fn) ->
    url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{config.appID}&secret=#{config.appSecret}"
    request {url,timeout:3000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.errcode?
          fn new Error res.errmsg
        else
          res.startTime = Date.now()
          global.accessToken = res
          fn null,res

  @codeAccessToken:(code,fn) ->
    url = "https://api.weixin.qq.com/sns/oauth2/access_token?grant_type=authorization_code&appid=#{config.appID}&secret=#{config.appSecret}&code=#{code}"
    request {url,timeout:3000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.errcode?
          fn new Error res.errmsg
        else
          fn null,res

  @jsapi:(url,fn) ->
    async.auto
      getTicket:(cb) ->
        if global.jsticket and global.jsticket.startTime+(global.jsticket.expires_in*1000)>Date.now()
          cb null,global.jsticket
        else
          WeixinCtrl.jsTicket (err,res) ->
            cb err,res
      sign:["getTicket",(cb,results) ->
        createRamdomNonceStr = () ->
          $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
          maxPos = $chars.length
          noceStr = ""
          for i in [0...32]
            noceStr += $chars.charAt(Math.floor(Math.random() * maxPos))
          noceStr
        ticket = results.getTicket
        noncestr = createRamdomNonceStr()
        timestamp = Math.floor(Date.now()/1000)
        signStr = "jsapi_ticket=#{ticket.ticket}&noncestr=#{noncestr}&timestamp=#{timestamp}&url=#{url}"
        crypto = require("crypto");
        shasum = crypto.createHash("sha1");
        shasum.update(signStr);
        signature = shasum.digest("hex");
        cb null,
          appId: config.appID,
          timestamp:timestamp
          nonceStr: noncestr
          signature: signature
          jsApiList: [
            "checkJsApi"
            "onMenuShareTimeline"
            "onMenuShareAppMessage"
            "onMenuShareQQ"
            "onMenuShareWeibo"
            "hideMenuItems"
            "showMenuItems"
            "hideAllNonBaseMenuItem"
            "showAllNonBaseMenuItem"
            "translateVoice"
            "startRecord"
            "stopRecord"
            "onRecordEnd"
            "playVoice"
            "pauseVoice"
            "stopVoice"
            "uploadVoice"
            "downloadVoice"
            "chooseImage"
            "previewImage"
            "uploadImage"
            "downloadImage"
            "getNetworkType"
            "openLocation"
            "getLocation"
            "hideOptionMenu"
            "showOptionMenu"
            "closeWindow"
            "scanQRCode"
            "chooseWXPay"
            "openProductSpecificView"
            "addCard"
            "chooseCard"
            "openCard"
          ]
      ]
    ,(err,results) ->
        fn err,results.sign

  @jsTicket:(fn) ->
    async.auto
      accessToken:(cb) ->
        if global.accessToken? and global.accessToken.startTime+(global.accessToken.expires_in*1000)>Date.now()
          cb null,global.accessToken
        else
          WeixinCtrl.accessToken (err,res) ->
            cb err,res
      ticket:["accessToken",(cb,results) ->
        at = results.accessToken.access_token
        url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{at}&type=jsapi"
        request {url,timeout:3000},(err,response,body) ->
          if err
            cb err
          else
            res = if body? then JSON.parse(body) else {}
            if res.errcode is not 0
              cb new Error res.errmsg
            else
              cb null,res
      ]
      ,(err,results) ->
        fn err,results.ticket


module.exports = WeixinCtrl
