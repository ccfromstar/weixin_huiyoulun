request = require "request"
config = require "./../config/config.json"
class ProductCtrl
  @productList: (fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/product/getlist?recommendedOnly=true&order=startDate"
    request {url,timeout:10000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

  @getSearchResult:(startDate,cruiseArea,departureLocation,cruiseCompanyId,shipId,fn) ->

    url = "#{config.inf.host}:#{config.inf.port}/product/getSearchResult?time=#{Date.now()}&startDate=#{startDate}&cruiseArea=#{cruiseArea}&departureLocation=#{encodeURIComponent(departureLocation)}&cruiseCompanyId=#{cruiseCompanyId}&shipId=#{shipId}"
    console.log url
    request {url,timeout:10000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

  @productDetail:(pid,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/product/getdetail?productId=#{pid}"
    request {url,timeout:10000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

  @productFee:(pid,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/product/getfees?productId=#{pid}"
    request {url,timeout:10000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

  @shipInfo:(shipId,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/product/getShipInfo?shipId=#{shipId}"
    request {url,timeout:10000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

  @sendMsg:(name,tel,email,product,sendtoid,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/User/SendMessage?name=#{encodeURIComponent(name)}&tel=#{tel}&email=#{email}&product=#{product}&sendtoid=#{sendtoid}"
    console.log url
    request {url,timeout:10000},(err,response,body) ->
      if err
        fn err
      else
        fn null,body
module.exports = ProductCtrl