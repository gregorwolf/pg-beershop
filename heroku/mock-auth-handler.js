// XSUAA doesn't work in heroku environment, so you should provide your own authentication handler and strategy
// in this example, no auth method is provided
module.exports = (req, res, next) => {
      req.user = new cds.User.Privileged()
      return next()
}