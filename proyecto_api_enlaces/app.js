const express = require("express");
const app = express();
const port = "5050";

app.get('/', (req, res) => {
    res.send('ok');
});

app.post('/', (req, res) => {
    res.send('ok 2');
});


app.listen(port, () => console.log(`App running on port ${ port }`));
