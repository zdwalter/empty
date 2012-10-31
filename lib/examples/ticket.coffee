module.exports =
    name: "ticket"
    url: "/api/ticket"
    method: "POST"
    input: [
        name: "topic"
        value: "input topic here"
        comment: "Topic of the ticket"
        type: "string"
        required: true
    ,
        name: "content"
        value: "input ticket content here"
        comment: "What's your ticket?"
        type: "string"
        required: true
    ]
    output:
        error: 0
        message: "Thanks for your information."
        url: "http://support.doit.im/ticket/:id"


