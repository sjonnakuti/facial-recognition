var path = require('path');
var Hapi = require('hapi');
var fs = require('fs')
var config = require('./config.js')
var AWS = require('aws-sdk')
AWS.config.region = config.region

var rekognition = new AWS.Rekognition({region: config.region});

var server = Hapi.createServer('localhost', Number(process.argv[2] || 8089));
server.views({
    engines: {
        html: require('handlebars')
    },
    path: 'public'
});

var routes=[

    {
        method: 'POST',
        path: '/upload',
        config: {
            handler: function (req, reply) {
                fs.readFile(req.payload.image_file, function (err, data) {
                    var now = new Date();
                    now = now.toJSON().toString();
                    var imageName = now + ".jpg";

                    var params  = {
                        "Attributes":["ALL"],
                        "Image":{
                            "Bytes":req.payload.image_file
                        }
                    };

                    rekognition.detectFaces(params, function(err, data){
                        if(err){
                            reply("Ooops! ",err.message);
                        }else{
                            reply(data.FaceDetails[0].Smile.Confidence);
                        }
                    });
                });
            }
        }
    }
]
server.route(routes);
server.start(function(req, res){
    console.log("hello , server is available at ", server.info.uri);
});
