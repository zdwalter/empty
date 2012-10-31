module.exports =
    name: "request"
    url: "/api/request"
    method: "POST"
    input: [
        name: "topic"
        value: "input topic here"
        comment: "Topic of the request"
        type: "string"
        required: true
    ,
        name: "content"
        value: "input request content here"
        comment: "What's your request?"
        type: "string"
        required: true
    ]
    output:
        error: 0
        message: "Thanks for your information."
        url: "http://support.doit.im/request/:id"


