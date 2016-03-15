ProductCtrl = require "./../ctrl/productCtrl"
CommonsCtrl = require "./../ctrl/commonsCtrl"
MemberCtrl = require "./../ctrl/memberCtrl"
WeixinCtrl = require "./../ctrl/weixinCtrl"
async = require "async"

#func = (i) ->
#  (cb) ->
#    MemberCtrl.getOption i,(err,res) ->
#      cb err,res
#
#arr = []
#for i in [1...300]
#  arr.push(func(i))
#
#async.series arr,(err,results) ->
#  console.log err,results

#WeixinCtrl.jsapi "tcjr.holidaycloud.cn",(err,res) ->
#  console.log err,res

#ProductCtrl.shipInfo 1,(err,res) ->
#  console.log err,res

#WeixinCtrl.accessToken (err,res) ->
#  console.log err,res

#MemberCtrl.login "emilyfan@hiuyoulun.com","lucy1126",(err,res) ->
#  console.log err,res
#
MemberCtrl.getOption 106,"odZ6Yt0D_IHamVTEstBksyxLigvU",(err,res) ->
  console.log err,res

#MemberCtrl.resetOption 106,"odZ6Yt0D_IHamVTEstBksyxLigvU",(err,res) ->
#  console.log err,res
#
#MemberCtrl.setOption 106,"美途","zzy","18918130030",(err,res) ->
#  console.log err,res

#MemberCtrl.weixinLogin "odZ6Yt0D_IHamVTEstBksyxLigvU",(err,res) ->
#  console.log err,res

#MemberCtrl.unbindWeChat "odZ6Yt0D_IHamVTEstBksyxLigvU",(err,res) ->
#  console.log err,res

#ProductCtrl.productList(null, null, null, null, null,true, (err,res) ->
#  console.log err,res
#)

#ProductCtrl.productDetail("1235",(err,res) ->
#  console.log err,res
#  console.log cat for cat in res.cabins
#)
#
#ProductCtrl.productFee("1098",(err,res) ->
#  console.log JSON.stringify(res)
#)

#CommonsCtrl.cruiseArea (err,res) ->
#  console.log err,JSON.stringify(res)

#CommonsCtrl.travelLocation (err,res) ->
#  console.log err,JSON.stringify(res)
#
#CommonsCtrl.ship (err,res) ->
#  console.log err,JSON.stringify(res)

#CommonsCtrl.productShip (err,res) ->
#  console.log err,JSON.stringify(res)