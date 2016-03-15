request = require "request"
config = require "./../config/config.json"
class MemberCtrl
  @login:(loginName,password,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/User/authUser?loginName=#{loginName}&password=#{password}"
    request {url,timeout:3000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

  @weixinLogin:(openid,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/User/authUser?openId=#{openid}"
    request {url,timeout:3000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

  @bindWeChat:(loginName,password,openid,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/User/bindWeChat?loginName=#{loginName}&password=#{password}&openId=#{openid}"
    request {url,timeout:3000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

  @unbindWeChat:(openid,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/User/unbindWeChat?openId=#{openid}"
    request {url,timeout:3000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

  @getOption:(id,openid,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/User/getOption?id=#{id}&openid=#{openid}"
    request {url,timeout:3000},(err,response,body) ->
      if err
        fn err
      else
        try
          res = if body? then JSON.parse(body) else {}
          if res.error?
            fn new Error(res.error)
          else
            fn null,res
        catch e
          fn e


  @setOption:(id,company,name,tel,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/User/setOption?id=#{id}&weixin_companyname=#{encodeURIComponent(company)}&weixin_name=#{encodeURIComponent(name)}&weixin_tel=#{tel}"
    request {url,timeout:5000},(err,response,body) ->
      if err
        fn err
      else
        fn null,body

  @resetOption:(id,openid,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/User/resetOption?id=#{id}&openid=#{openid}"
    request {url,timeout:5000},(err,response,body) ->
      if err
        fn err
      else
        fn null,body

module.exports = MemberCtrl