express = require "express"
path = require "path"
favicon = require "static-favicon"
cookieParser = require "cookie-parser"
session = require "cookie-session"
bodyParser = require "body-parser"
config = require "./config/config.json"


log4js = require "log4js"
log4js.configure appenders:[type:"console"],replaceConsole:true
logger = log4js.getLogger "normal"

index = require "./routes/index"
weixin = require "./routes/weixin"
app = express()

app.set "views",path.join __dirname,"views"
app.set "view engine","ejs"
app.enable "trust proxy"
app.use favicon()
app.use bodyParser.json()
app.use bodyParser.urlencoded()
#app.use bodyParser.text(type:"text/xml")
app.use cookieParser()
app.use express.static path.join __dirname,"public"
app.use log4js.connectLogger logger,level:log4js.levels.INFO
app.use(session({
  secret:'huiyoulun'
}));
app.use (req,res,next) ->
  res.set "X-Powered-By","Server"
  next()

app.use (req,res,next) ->
  res.locals.user = req.session.user
  next()

app.use "/",index
app.use "/weixin",weixin

app.use (req,res,next) ->
  res.status(404).end()

if (app.get "env") is "development"
  app.use (err,req,res,next) ->
    console.log err
    res.status(err.status or 500).end()

app.use (err,req,res,next) ->
  console.log err
  res.status(err.status or 500).end()

app.set "port",process.env.PORT or 3000

server = app.listen (app.get "port"),() ->
  console.log "Express server listening on port #{server.address().port}"
module.exports = app