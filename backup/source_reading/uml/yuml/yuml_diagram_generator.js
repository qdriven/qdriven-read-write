const generator= require("yuml-diagram");
const fs = require('fs');

var yuml      = new generator()
var yumlTextg = fs.readFileSync("./design-pattern/builder.yuml",{encoding:"utf-8"});
console.log(yumlTextg)
var svgDarkBg = yuml.processYumlDocument(yumlTextg, false);
fs.writeFileSync("./test.yuml.svg", svgDarkBg);
