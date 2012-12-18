apiHost = window.location.host
APIModel = Backbone.Model.extend
  url: "/api/examples"
  #defaults:
  #  name: "example"
  #  url: "/api/examples"
  #  method: 'GET'
  #  input: [
  #    name: "input1"
  #    value: "test"
  #    comment: "just for test"
  #    type: "string"
  #    required: true
  #  ,
  #    name: "input2"
  #    value: 123
  #    type: "number"
  #    required: false
  #  ]
  #  output:
  #    status: 0
  #    msg: "ok"
  #    data: "lalala"

APIExamples = Backbone.Collection.extend
  model: APIModel
  url: "/api/examples"
  findByName: (name) ->
    self = @toJSON()
    for e in self
      return e if e.name is name

APIList = Backbone.View.extend
  el: "#APIList"
  #events:
  #  "click li": "show"
  show: (name) ->
    console.log name
    #target = $("##{name}")
    $(@el).find('li').removeClass 'active'
    #target.addClass 'active'
    $(@el).find('li').each((index, item) ->
      if item.innerText.trim() is name
        $(item).addClass 'active'
    )
    api = apiExamples.findByName(name)
    console.log api
    apiView.render(api)
  render: () ->
    view = ich.APIList(examples: apiExamples.toJSON())
    $(@el).html(view)

APIView = Backbone.View.extend
  el: "#API"
  api: null
  events:
    "click #run": "run"
    "keyup input": "inputChanged"
    "change select": "selectChanged"
    #"enter input": "onEnter"
  onEnter: () ->
    console.log('enter')
  selectChanged: (e) ->
    #alert('selectChanged')
    target = e.currentTarget
    for input in @api.input
      if input.name is target.name
        console.log input.value, target.value
        input.value = target.value
  run: () ->
    self = @
    api = @api
    api.output = 'loading...'
    self.render(api)
    console.log "run #{api.realUrl}"
    data = {}
    noData = true
    for input in api.input
      continue if input.removed? or not input.value?
      noData = false
      console.log "input.value is :" , input.value
      keys = input.name.split('.')
      if keys.length is 2
        console.log keys[0], keys[1]
        data[keys[0]] = {} if not data[keys[0]]?
        data[keys[0]][keys[1]] = input.value.toString().trim()
      else
        if input.type is 'array'
          data[input.name] = input.value.toString().trim().split(',')
        else
          data[input.name] = input.value.toString().trim()


    if api.method in ['GET','get', 'DELETE', 'delete', 'PUT', 'put']
      $.ajax
        url: api.realUrl
        type: api.method
        data: data
        success: (res) ->
          console.log JSON.stringify(res)
          api.output = res
          console.log api.output
          self.render(api)
        error: (e) ->
          console.log e
          api.output = e
          self.render(api)
    else
      if noData
        data = null
      else
        data = JSON.stringify(data)
      $.ajax
        url: api.realUrl
        type: api.method
        data: data
        dataType: 'json'
        contentType: "application/json; charset=utf-8"
        success: (res) ->
          console.log JSON.stringify(res)
          api.output = res
          self.render(api)
        error: (e) ->
          console.log e
          api.output = e
          self.render(api)
 
  inputChanged: (e) ->
    if e.keyCode is 13
      return @run()
    target = e.currentTarget
    for input in @api.input
      input.value = target.value if input.name is target.name
  render: (api) ->
    @api = api
    #get query string
    getQuery = (input) ->
      query_str = '?'
      for input_item in input
        continue if input_item.removed? or not input_item.value?
        query_str += input_item.name + '=' + input_item.value + '&'
      query_str = query_str.slice(0, query_str.length-1)
    api.realUrl = api.url

    for item, i in api.input
      k = item.name
      v = item.value
      console.log k, ' - ', v
      match = api.realUrl.match("{#{k}}")
      console.log match, k
      if match
        api.realUrl = api.realUrl.replace("{#{k}}", v)
        item.removed = true

    if api.method in ['GET','get', 'DELETE', 'delete', 'PUT', 'put']
      api.link = "http://#{apiHost}#{api.realUrl}#{getQuery(api.input)}"
    else
      api.link = "http://#{apiHost}#{api.realUrl}"
    view = ich.API(api)
    $(@el).html(view)

APIRoute = Backbone.Router.extend
  initialize: () ->
    console.log "init"
  routes:
    "": "welcome"
    "about": "about"
    "api/:name": "showAPI"
    "api/status/:status":"showStatus"
    "api/user/:user":"showUser"
  welcome: () ->
    console.log "welcome"
  about: () ->
    console.log "about"
  showAPI: (name) ->
    console.log "showAPI #{name}"
    apiList.show(name)
  showStatus: (status) ->
    console.log "showStatus #{status}"
    @showAPI("status/#{status}")
  showUser: (user) ->
    console.log "showUser #{user}"
    @showAPI("user/#{user}")
    #window.api = null
window.apiExamples = new APIExamples
window.apiList = new APIList
window.apiView = new APIView
window.router = new APIRoute

$(document).ready () ->
  console.log "ready"
  apiExamples.fetch
    success: (collection) ->
      console.log JSON.stringify(apiExamples)
      apiList.render()
      Backbone.history.start()

    error: () ->
      console.log "Error fetch apiExamples"
