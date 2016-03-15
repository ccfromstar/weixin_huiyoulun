express = require "express"
router = express.Router()

WeixinAction = require "./../action/weixinAction"

router.get "/",WeixinAction.check
router.post "/",WeixinAction.msg

module.exports = router