request = require "request"
config = require "./../config/config.json"
class CommonsCtrl
  @cruiseArea:(fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/cruisearea/getall"
    request {url,timeout:3000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

  @travelLocation:(fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/travellocation/getStartLocations"
    request {url,timeout:3000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

  @ship:(fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/ship/getcompanies"
    request {url,timeout:3000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

  @productShip:(fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/ship/getAllShipHasProduct"
    request {url,timeout:3000},(err,response,body) ->
      if err
        fn err
      else
        res = if body? then JSON.parse(body) else {}
        if res.error?
          fn new Error(res.error)
        else
          fn null,res

module.exports = CommonsCtrl