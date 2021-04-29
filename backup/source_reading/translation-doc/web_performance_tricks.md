# Web Performance Tricks

CPU Activity
![CPU Activity](cpu_activity.jpg)

## Six Principles

- Quickly Response to Network Request
- Minimize Bytes Download
- Efficiently Structure Markup
- Optimize Media Usage
- Write Fast Javascript
- Know What your application is doing

## Quickly Response to Network Request

- Avoid 3XX Redirection

```
Request
GET /HTTP/1.1
Host: www.news.com
```

```
Response
HTTP/1.1 303 See others
Location: www.homepage.news.com
```

- Avoid Meta Refresh Tag

```
<!-- bad sample -->
 <meta http-equiv="refresh" content="url=http://news.com/"/>
 ```

 - Use CDN
 - Maximize Concurrent Connections 

```
HTTP Response
HTTP/1.1 200 OK
Content-Type: application/javascript
Content-Length: 230848
Connection: close
```

connection 换成keep-alive

- know your server
- understand your network timing

|unload|redirect|app cache|DNS|TCP|Request|Response|Processing|onLoad|
|--|--|--|--|--|--|--|--|--|
||||||||||

## Download Fewer Request and Bytes

主要下载内容：
  - image
  - scripts
  - Flash
  - HTML
  - CSS
  - Other

方法：
- GZIP Compress Network Traffic
  * deflate??
- Persist App Resource Locally in package
- Cache Dynamic Resource in App Cache - how to update the new resources from the server?
- Provide Cacheable content- Content Expired in Header
- Send Conditional Request - If-Modified-Since/Last-Modified
- Cache Data Request
- Standardize File Capitalization Convention

## Efficiently Structure Markup

- Load Pages in Latest Browser Mode (HTML5)
- Use HTTP Header to Specify Legacy IE Modes

```
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7">
HTTP Header
HTTP/1.1 200 OK
Date:  Sun, 14 Mar 2010 21:30:46 GMT
X-UA-Compatible: IE=EmulateIE7
```
- Link Style Sheets at Top of Page and Never Link Style Sheets at Bottom of Page
- Avoid Using @import for Hierarchical Styles
- Avoid Embedded and Inline Styles
- only Include Necessary Styles
- Always Link JavaScript at End of File
- Avoid Linking JavaScript In Head
- Avoid Inline JavaScript
- Use the Defer Tag When Head Only Option
- Asynchronously Download Script

```HTML
<script async src="myscript.js"></script>
```
- Remove Duplicate Code
- Standardize on a Single Framework
- Don’t Include Script To Be Cool

## Optimize Media Usage

- Avoid Death by 1000 images
- Image Sprites
- Create your Sprites by Hand
- Replace Images with CSS3 Gradients Optimize
- Use DataURI’s for Small Single View Images
- Avoid Complex SVG Paths Optimize
- Video: User Preview Images
- stock to integer Math



## Write fast JavaScript

- Stick to Integer Math 

```
DoMath(Math.floor(999 / 2));

var b = Math.ceil((p[i].r + p[i].g + p[i].b) / 3);
```

- Minify your Javascript

```
function Sum(number1, number2) {
    return (number1 + number2);
}
function Sum(number1,number2){return number1+number2;}

function Sum(a,b){return a+b;}
```

- Initialize JavaScript on Demand 
- Minimize DOM Interactions 
- Built in DOM Methods Always More Efficient 
- Use Selectors API for Collection Access 
- User .innerHTML to Construct Your Page 
- Batch Markup Changes 
- Maintain a Small and Healthy DOM 
- JSON Always Faster than XML for Data 
- Use Native JSON Methods 
- Use Regular Expressions Sparingly 


## Know What your application is doing

- setTimeOut
- setInterval
- combine application timer
- align timers to the display frame
- use requestAnimationFrame for animation
- know when your app is visible



-
