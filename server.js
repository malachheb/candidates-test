var express    = require('express');
var bodyParser = require('body-parser');
var app        = express();
var morgan     = require('morgan');

var components = require('./components.json');
var users      = require('./users.json');
app.use(morgan('dev')); 

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 3000; 

var router = express.Router();

router.use(function(req, res, next) {
	next();
});

router.get('/', function(req, res) {
	res.json({ message: 'API started' });	
});

router.route('/components')

	.get(function(req, res) {
		res.json(components);
		});

router.route('/users')

	.get(function(req, res) {
		res.json(users);
		});

app.use('/api', router);

app.listen(port);
console.log('Server running on port ' + port);
