const fs = require('fs');
const util = require('util');
let express = require('express');
let bodyParser = require('body-parser');
let app = express();
//let redirectToHTTPS = require('express-http-to-https').redirectToHTTPS;

const writeFile = util.promisify(fs.writeFile);

const HOST = 'ftp://46.101.213.230:32021/incoming';
const TIMEOUT = 43200000; // in milliseconds 12 hours
let roomIds = [];

const deleteFile = (file) => {
    roomIds = roomIds.filter(function(item) {
        return item !== file;
    });
    fs.unlink(file, (err) => {
        if (err) {
            console.log(err);
        }
        console.log(`${file} was deleted`);
    })
};

//Allow all requests from all domains & localhost
app.all('/*', function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type, Accept");
    res.header("Access-Control-Allow-Methods", "POST, GET");
    next();
});

//app.use(redirectToHTTPS([/localhost:6069/]));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));

app.get('/', function(req, res) {
  res.send('hello world');
});

app.post('/generateRoomIdLink', function(req, res) {
    console.log(req.body);
    //income
    let link = req.body.link;
    let roomId = req.body.roomId;

    let output = `${HOST}/${roomId}.html`;

    /// Creating file with a link
    // let fileName = `${roomId}.html`;
    let fileName = `/var/lib/ftp/incoming/${roomId}.html`;
    let content = `<!DOCTYPE html><html>
<head>
	<title></title>
	<script type="text/javascript">
        window.open("${link}", "_self");
	</script>
</head>
<body>
</body>
</html>`;
    if (!roomIds.includes(fileName)) {
        writeFile(fileName, content)
            .then(() => {
                console.log(`file ${fileName} has been created!`);
                setTimeout(() => deleteFile(fileName), TIMEOUT);
                roomIds.push(fileName);
                res.status(200).send({ftpLink:output});
            }).catch((err) => {
            console.log(err);
            res.status(500).send('Something happened on server. Sorry...');
        });
    } else {
        res.status(500).send('Something happened on server. Sorry...');
    }
});


app.listen(6069, () => {
    console.log(`Server listening on port 6069`);
});
