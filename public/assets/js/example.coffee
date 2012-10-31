apiHost = window.location.host
APIModel = Backbone.Model.extend
    url: "/api/examples"
    defaults:
        name: "example"
        url: "/api/examples"
        input: [
            name: "input1"
            value: "test"
            comment: "just for test"
            type: "string"
            required: true
        ,
            name: "input2"
            value: 123
            type: "number"
            required: false
        ]
        output:
            status: 0
            msg: "ok"
            data: "lalala"

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
    #    "click li": "show"
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
        #"enter input": "onEnter"
    onEnter: () ->
        console.log('enter')
    run: () ->
        self = @
        api = @api
        api.output = 'loading...'
        self.render(api)
        console.log "run #{api.url}"
        data = {}
        for input in api.input
            console.log "input.value is :" , input.value
            data[input.name] = input.value.toString().trim()

        $.ajax
            url: api.url
            type: api.method
            data: data
            dataType: 'json'
            success: (res) ->
                console.log JSON.stringify(res)
                api.output = res
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
                query_str += input_item.name + '=' + input_item.value + '&'
            query_str = query_str.slice(0, query_str.length-1)
        if api.method in ['GET','get']
            api.link = "http://#{apiHost}#{api.url}#{getQuery(api.input)}"
        else
            api.link = "http://#{apiHost}#{api.url}"
        api.output = JSON.stringify(api.output, null, 4)
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
