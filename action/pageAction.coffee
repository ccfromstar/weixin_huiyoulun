ProductCtrl = require "./../ctrl/productCtrl"
CommonsCtrl = require "./../ctrl/commonsCtrl"
MemberCtrl = require "./../ctrl/memberCtrl"
WeixinCtrl = require "./../ctrl/weixinCtrl"
async = require "async"
exports.weixinLogin = (req,res,next) ->
  if req.session.user?
    next()
  else
    openid = req.query.openid
    code = req.query.code
    if code?
      console.log "----------weixinLogin------------"
      state = req.query.state
      async.auto
        getOpenid:(cb) ->
          WeixinCtrl.codeAccessToken code,(err,result) ->
            console.log "----------codeAccessToken------------"
            if err?
              cb err
            else if result.errcode?
              cb new Error result.errmsg
            else
              cb null,result
        autoLogin:["getOpenid",(cb,results) ->
          openid = results.getOpenid.openid
          MemberCtrl.weixinLogin openid,(err,result) ->
            console.log "----------autoLogin------------"
            console.log err,result
            cb err,result
        ]
        getOptions:["autoLogin","getOpenid",(cb,results)->
          openid = results.getOpenid.openid
          uid = results.autoLogin.id
          MemberCtrl.getOption uid,openid,(err,result) ->
            cb err,result
        ]
        ,(err,results) ->
          openid = results.getOpenid.openid
          if not err?
            user = results.getOptions
            user.openid = openid
            user.id = results.autoLogin.id
            res.locals.user = user
            req.session.user = user
          next()
    else if openid?
      console.log "----------openid login------------"
      async.auto
        autoLogin:(cb,results) ->
          MemberCtrl.weixinLogin openid,(err,result) ->
            console.log "----------autoLogin------------"
            console.log err,result
            cb err,result
        getOptions:["autoLogin",(cb,results)->
          uid = results.autoLogin.id
          MemberCtrl.getOption uid,openid,(err,result) ->
            cb err,result
        ]
        ,(err,results) ->
            console.log err,results
            if not err?
              user = results.getOptions
              user.openid = openid
              user.id = results.autoLogin.id
              res.locals.user = user
              req.session.user = user
            next()
    else
      next()

exports.login = (req,res) ->
  code = req.query.code
  state = req.query.state
  if code?
    WeixinCtrl.codeAccessToken code,(err,result) ->
      if err
        res.status(500).end()
      else
        res.render "login",openid:result.openid
  else
    res.render "login",openid:""

exports.setting = (req,res) ->
  code = req.query.code
  state = req.query.state
  if code
    async.auto
      getOpenid:(cb) ->
        WeixinCtrl.codeAccessToken code,(err,result) ->
          console.log "getOpenid",err,result
          if err?
            cb err
          else if result.errcode?
            cb new Error result.errmsg
          else
            cb null,result
      autoLogin:["getOpenid",(cb,results) ->
        openid = results.getOpenid.openid
        MemberCtrl.weixinLogin openid,(err,result) ->
          console.log "autoLogin",err,result
          cb err,result
      ]
      getOptions:["autoLogin","getOpenid",(cb,results)->
        uid = results.autoLogin.id
        openid = results.getOpenid.openid
        MemberCtrl.getOption uid,openid,(err,result) ->
          cb err,result
      ]
      weixin:(cb) ->
        url = "http://#{req.hostname}#{req.url}"
        WeixinCtrl.jsapi url,(err,result) ->
          console.log "weixin",err,result
          cb err,result
    ,(err,results) ->
      if not err?
        uid = results.autoLogin.id
        user = results.getOptions
        openid = results.getOpenid.openid
        user.openid = openid
        user.id = uid
        res.locals.user = user
        req.session.user = user
      res.render "setting",uid:uid,weixin:results.weixin,user:user,openid:openid
  else
    res.render "setting",uid:"",weixin:null,user:null,openid:null



exports.unbind = (req,res) ->
  code = req.query.code
  state = req.query.state
  async.auto
    getOpenid:(cb) ->
      WeixinCtrl.codeAccessToken code,(err,result) ->
        cb err,result
    weixin:(cb) ->
      url = "http://#{req.hostname}#{req.url}"
      WeixinCtrl.jsapi url,(err,result) ->
        cb err,result
    ,(err,results) ->
      if err
        res.status(500).end()
      else
        res.render "unbind",weixin:results.weixin,openid:results.getOpenid.openid

exports.doLogin = (req,res) ->
  loginName = req.body.loginName
  password = req.body.password
  openid = req.body.openid
  async.auto
    autoLogin:(cb,results) ->
      MemberCtrl.bindWeChat loginName,password,openid,(err,result) ->
        cb err,result
    getOptions:["autoLogin","getOpenid",(cb,results)->
      uid = results.autoLogin.id
      MemberCtrl.getOption uid,openid,(err,result) ->
        cb err,result
    ]
    ,(err,results) ->
      if not err?
        user = results.getOptions
        user.openid = openid
        user.id = results.autoLogin.id
        res.locals.user = user
        req.session.user = user
        res.send "success"
      else
        res.send err.message

exports.resetOption = (req,res) ->
  uid = req.body.uid
  openid = req.body.openid
  MemberCtrl.resetOption uid,openid,(err,result) ->
    if not err?
      res.send "success"
    else
      res.send err.message

exports.doSetting = (req,res) ->
  company = req.body.company
  name = req.body.name
  tel = req.body.tel
  uid = req.body.uid
  MemberCtrl.setOption uid,company,name,tel,(err,result) ->
    if not err?
      res.send "success"
    else
      res.send err.message

exports.doUnbind = (req,res) ->
  openid = req.body.openid
  MemberCtrl.unbindWeChat openid,(err,result) ->
    if not err?
      req.session.user = null
      res.send "success"
    else
      res.send err.message

exports.checkLogin = (req,res,next) ->
  if req.session.user?
    next()
  else
    res.render "login"

exports.index = (req,res) ->
  async.auto
    products:(cb) ->
      ProductCtrl.productList (err,result) ->
        cb err,result
    weixin:(cb) ->
      url = "http://#{req.hostname}#{req.url}"
      WeixinCtrl.jsapi url,(err,result) ->
        cb err,result
    ,(err,results) ->
      console.log results.products.productList
      r = {}
      r.weixin = results.weixin
      r.products = results.products.productList
      res.render "index",r

exports.search = (req,res) ->
  async.auto
    cruiseArea:(cb) ->
      CommonsCtrl.cruiseArea (err,res) ->
        cb err,res
    travelLocation:(cb) ->
      CommonsCtrl.travelLocation (err,res) ->
        cb err,res
    ship:(cb) ->
      CommonsCtrl.ship (err,res) ->
        cb err,res
    productShip:(cb) ->
      CommonsCtrl.productShip (err,res) ->
        cb err,res
    ,(err,results) ->
      res.render "search",results

exports.searchReults = (req,res) ->
  startDate = req.body.startDate
  cruiseArea = req.body.cruiseArea
  departureLocation = req.body.travelLocation
  cruiseCompanyId = req.body.cruiseCompanyId
  shipId = req.body.shipId
  ProductCtrl.getSearchResult startDate,cruiseArea,departureLocation,cruiseCompanyId,shipId,(err,result) ->
    res.render "searchResult",ships:result

exports.priceDetail = (req,res) ->
  pid = req.params.pid
  async.auto
    detail:(cb) ->
      ProductCtrl.productDetail pid,(err,result) ->
        cb err,result
    weixin:(cb) ->
      url = "http://#{req.hostname}#{req.url}"
      WeixinCtrl.jsapi url,(err,result) ->
        cb err,result
  ,(err,results) ->
    r = results.detail
    r.weixin = results.weixin
    res.render "priceDetail",r

exports.detail = (req,res) ->
  pid = req.params.pid
  async.auto
    detail:(cb) ->
      ProductCtrl.productDetail pid,(err,result) ->
        cb err,result
    fee:(cb) ->
      ProductCtrl.productFee pid,(err,result) ->
        cb err,result
    ship:["detail",(cb,results) ->
      detail = results.detail
      ProductCtrl.shipInfo detail.product.ship_id,(err,result) ->
        cb err,result
    ]
    weixin:(cb) ->
      url = "http://#{req.hostname}#{req.url}"
      WeixinCtrl.jsapi url,(err,result) ->
        cb err,result
    ,(err,results) ->
      r = results.detail
      r.fees = results.fee.fees
      r.ship = results.ship
      r.weixin = results.weixin
      res.render "prodInfo",r

exports.sendMsg = (req,res) ->
  name = req.body.name
  tel = req.body.tel
  pid = req.body.pid
  email = req.body.email
  sendtoid = req.body.sendtoid
  ProductCtrl.sendMsg name,tel,email,pid,sendtoid,(err,result) ->
    res.send result