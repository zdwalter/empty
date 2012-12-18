module.exports =
    name: "migrate"
    url: "/migrate"
    method: "GET"
    input: [
        name: "username"
        value: "email@xxx.com"
        comment: "email"
        type: "string"
        required: true
    ]
    output:
        error: 0


