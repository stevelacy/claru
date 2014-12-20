module.exports = (user) ->
  return '' unless user?
  u =
    name: user.name
    email: user.email
    token: user.token
    image: user.image
    online: user.online
  return u
