https = require("https")

module.exports = {
  request: (reqUrl, cb) ->
    req = https.request(reqUrl, (res) ->
      chunks = ""

      res.on('data', (chunk) ->
        if chunk?.status == "error"
          cb(new Error("Recieved error: #{chunk}"), null)
        else
          chunks += chunk
      )
      res.on("end", ->
        if res.statusCode isnt 200
          cb(new Error("Bad Status code: #{res.statusCode}"), null)
        else
          cb(null, chunks)
      )
    )
    req.end()

    req.on('error', (e) ->
      return cb(e, null)
    )
}
