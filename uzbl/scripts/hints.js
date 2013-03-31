/* This is a linkfollowing script.
 *
 * TODO: Some pages mess around a lot with the zIndex which
 * lets some hints in the background.
 * TODO: Some positions are not calculated correctly (mostly
 * because of uber-fancy-designed-webpages. Basic HTML and CSS
 * works good
 * TODO: Still some links can't be followed/unexpected things
 * happen. Blame some freaky webdesigners ;)
 */
 
 
/* example bindings
set javascript_windows = 1
set follow_hint_keys = asd
@bind    <Tab>        = script @sdir/follow.js '@{follow_hint_keys} '
@bind    `            = script @sdir/follow.js '@{follow_hint_keys} clear'
@bind    q_           = script @sdir/follow.js '@{follow_hint_keys} %s'
@bind    w_           = script @sdir/follow.js '@{follow_hint_keys} new %s'
 
// optional, this shows what the link is without visiting it
// Note that you are supposed to have pressed <Tab> before you use e_ binding.
set selected_section  = <span foreground="#606060">\@[\@<if ("\@followuri" != "") "\@followuri"; else "\@SELECTED_URI";>\@]\@</span>
@bind    e_           = set followuri = \@<followLinks('%s', true)>\@
@on_event   LINK_HOVER set followuri =
 
// One more option, useful for things like "just click the link"
@on_event LOAD_START  = js function followLinksClickCallback (item) {item.click();};
@bind     c_          = script @sdir/follow.js '@{follow_hint_keys} callback %s'
*/
 
//Just some shortcuts and globals
 
var LINK  = 0;
var FORM  = 1;
var IMAGE = 2;
 
var uzblid = 'uzbl_link_hint';
var uzbldivid = uzblid + '_div_container';
var doc = document;
var win = window;
var links = document.links;
var forms = document.forms;
var images = document.images;
var newwindow = false;
var justreturn = false;
var usecallback = false;
 
function contains(a, o) {
    for(var i = 0; i < a.length; i++) {
        if(a[i] === o) {
            return true;
        }
    }
    return false;
}
 
//Make onlick-links "clickable"
try {
    HTMLElement.prototype.click = function() {
        if (typeof this.onclick == 'function') {
            this.onclick({
                type: 'click'
            });
        }
    };
} catch(e) {}
//Catch the ESC keypress to stop linkfollowing
function keyPressHandler(e) {
    var kC = window.event ? event.keyCode: e.keyCode;
    var Esc = window.event ? 27 : e.DOM_VK_ESCAPE;
    if (kC == Esc) {
        removeAllHints();
    }
}
//Calculate element position to draw the hint
//Pretty accurate but on fails in some very fancy cases
function elementPosition(el) {
    var up = el.offsetTop;
    var left = el.offsetLeft;
    var width = el.offsetWidth;
    var height = el.offsetHeight;
    while (el.offsetParent) {
        el = el.offsetParent;
        up += el.offsetTop;
        left += el.offsetLeft;
    }
    return [up, left, width, height];
}
//Calculate if an element is visible
function isVisible(el) {
    if (el == doc) {
        return true;
    }
    if (!el) {
        return false;
    }
    if (!el.parentNode) {
        return false;
    }
    if (el.style) {
        if (el.style.display == 'none') {
            return false;
        }
        if (el.style.visibility == 'hidden') {
            return false;
        }
    }
    return isVisible(el.parentNode);
}
//Calculate if an element is on the viewport.
function elementInViewport(el) {
    offset = elementPosition(el);
    var up = offset[0];
    var left = offset[1];
    var width = offset[2];
    var height = offset[3];
    return up < window.pageYOffset + window.innerHeight && left < window.pageXOffset + window.innerWidth && (up + height) > window.pageYOffset && (left + width) > window.pageXOffset;
}
//Removes all hints/leftovers that might be generated
//by this script.
function removeAllHints() {
    var elements = doc.getElementById(uzbldivid);
    if (elements) {
        elements.parentNode.removeChild(elements);
    }
}
//Generate a hint for an element with the given label
//Here you can play around with the style of the hints!
function generateHint(el, label, type) {
    var pos = elementPosition(el);
    var hint = doc.createElement('div');
    hint.setAttribute('name', uzblid);
    hint.innerText = label;
    hint.style.display = 'inline';
 
    if (type == LINK) {
        hint.style.backgroundColor = '#000';
        // hint.style.border = '2px solid #4A6600';
    }
    if (type == FORM) {
        hint.style.backgroundColor = '#00B9FF';
        hint.style.border = '2px solid #004A66';
    }
    if (type == IMAGE) {
        hint.style.backgroundColor = '#FF00B9';
        hint.style.border = '2px solid #66004A';
    }
 
    hint.style.color = 'white';
    hint.style.fontSize = '10px';
    hint.style.fontWeight = 'bold';
    hint.style.lineHeight = '10px';
    hint.style.margin = '0px';
    hint.style.width = 'auto'; // fix broken rendering on w3schools.com
    hint.style.padding = '1px';
    hint.style.position = 'absolute';
    hint.style.zIndex = '1000';
    hint.style.fontFamily = 'monospace';
    //hint.style.opacity = '.7';
    // hint.style.textTransform = 'uppercase';
    //alert(hint.style.offsetWidth);
    //hint.style.left = (pos[1]-hint.style.width) + 'px';
 
    /*var l = pos[1]-25;
    if (l < 0) l = 0;*/
 
    var h = pos[0];
    if (type == IMAGE)
        h += 16;
    if (h < 0) h = 0;
 
    //var h = pos[0];
    var l = pos[1];
 
    hint.style.left = l + 'px';
    hint.style.top = h + 'px';
    // var img = el.getElementsByTagName('img');
    // if (img.length > 0) {
    //     hint.style.top = pos[1] + img[0].height / 2 - 6 + 'px';
    // }
    hint.style.textDecoration = 'none';
    // hint.style.webkitBorderRadius = '6px'; // slow
    // Play around with this, pretty funny things to do :)
    //hint.style.webkitTransform = 'scale(1) rotate(0deg) translate(-20px,-20px)';
    return hint;
}
//Here we choose what to do with an element if we
//want to "follow" it. On form elements we "select"
//or pass the focus, on links we try to perform a click,
//but at least set the href of the link. (needs some improvements)
function clickElem(item) {
    removeAllHints();
    if (usecallback) {
      return followLinksClickCallback(item);
    }
    if (item) {
        var name = item.tagName;
        if (name == 'A') {
            //item.click();
            if (newwindow)
                window.open(item.href);
            else if (justreturn)
                return item.href;
            else
                window.location = item.href;
        }
        else if (name == 'IMG') {
            if (newwindow)
                window.open(item.src);
            else if (justreturn)
                return item.src;
            else
                window.location = item.src;
        } else if (name == 'INPUT') {
            var type = (item.getAttribute('type') || 'text').toUpperCase();
            if (type == 'TEXT' || type == 'FILE' || type == 'PASSWORD') {
                item.focus();
                item.select();
                item.click();
            } else {
                item.click();
            }
        } else if (name == 'TEXTAREA' || name == 'SELECT') {
            item.focus();
            item.select();
        } else {
            item.click();
            if (newwindow)
                window.open(item.href, '', '');
            else if (justreturn)
                return item.href;
            else
                window.location = item.href;
        }
    }
}
//Returns a list of all links (in this version
//just the elements itself, but in other versions, we
//add the label here.
function addLinks() {
    res = [[], []];
    for (var l = 0; l < links.length; l++) {
        var li = links[l];
        if (isVisible(li) && elementInViewport(li)) {
            res[0].push(li);
        }
    }
    return res;
}
function addImages() {
    res = [[], []];
    for (var l = 0; l < images.length; l++) {
        var li = images[l];
        if (isVisible(li) && elementInViewport(li)) {
            res[0].push(li);
        }
    }
    return res;
}
//Same as above, just for the form elements
function addFormElems() {
    res = [[], []];
    for (var f = 0; f < forms.length; f++) {
        for (var e = 0; e < forms[f].elements.length; e++) {
            var el = forms[f].elements[e];
            if (el && ['INPUT', 'TEXTAREA', 'SELECT'].indexOf(el.tagName) + 1 && isVisible(el) && elementInViewport(el)) {
                res[0].push(el);
            }
        }
    }
    return res;
}
//Draw all hints for all elements passed. "len" is for
//the number of chars we should use to avoid collisions
function reDrawHints(elems, chars) {
    removeAllHints();
    var hintdiv = doc.createElement('div');
    hintdiv.setAttribute('id', uzbldivid);
    for (var i = 0; i < elems[0].length; i++) {
        if (elems[0][i]) {
            var label = elems[1][i].substring(chars);
            var h = generateHint(elems[0][i], label, elems[2][i]);
            hintdiv.appendChild(h);
        }
    }
    if (document.body) {
        document.body.appendChild(hintdiv);
    }
}
// pass: number of keys
// returns: key length
function labelLength(n) {
    var oldn = n;
    var keylen = 0;
    if(n < 2) {
        return 1;
    }
    n -= 1; // our highest key will be n-1
    while(n) {
        keylen += 1;
        n = Math.floor(n / charset.length);
    }
    return keylen;
}
// pass: number
// returns: label
function intToLabel(n) {
    var label = '';
    do {
        label = charset.charAt(n % charset.length) + label;
        n = Math.floor(n / charset.length);
    } while(n);
    return label;
}
// pass: label
// returns: number
function labelToInt(label) {
    var n = 0;
    var i;
    for(i = 0; i < label.length; ++i) {
        n *= charset.length;
        n += charset.indexOf(label[i]);
    }
    return n;
}
//Put it all together
function followLinks(follow, jr) {
    if (jr)
        justreturn = true;
    // if(follow.charAt(0) == 'l') {
    //     follow = follow.substr(1);
    //     charset = 'thsnlrcgfdbmwvz-/';
    // }
    var s = follow.split('');
    var linknr = labelToInt(follow);
    if (document.body) document.body.setAttribute('onkeyup', 'keyPressHandler(event)');
    var linkelems = addLinks();
    var formelems = addFormElems();
    var imgelems = addImages();
    var elems = [linkelems[0].concat(formelems[0]).concat(imgelems[0]), linkelems[1].concat(formelems[1]).concat(imgelems[1])];
    var len = labelLength(elems[0].length);
    var oldDiv = doc.getElementById(uzbldivid);
    var leftover = [[], [], []];
    if (s.length == len && linknr < elems[0].length && linknr >= 0) {
        return clickElem(elems[0][linknr]);
    } else {
        for (var j = 0; j < elems[0].length; j++) {
            var b = true;
            var label = intToLabel(j);
            var n = label.length;
            for (n; n < len; n++) {
                label = charset.charAt(0) + label;
            }
            for (var k = 0; k < s.length; k++) {
                b = b && label.charAt(k) == s[k];
            }
            if (b) {
                leftover[0].push(elems[0][j]);
                leftover[1].push(label);
 
                if (contains(linkelems[0], elems[0][j]))
                    leftover[2].push(LINK);
                else if (contains(formelems[0], elems[0][j]))
                    leftover[2].push(FORM);
                else if (contains(imgelems[0], elems[0][j]))
                    leftover[2].push(IMAGE);
            }
        }
        reDrawHints(leftover, s.length);
    }
}
 
var charset ;
 
function main (args_raw)
{
    //Parse input: first argument is follow keys, second is user input.
    var args = args_raw.split(' ');
    charset = args[0];
    if (args[1] == 'clear')
        removeAllHints();
    else {
        if (args[1] == "new") {
            newwindow = true;
            followLinks(args[2]);
        } else if (args[1] == "callback") {
            usecallback = true;
            followLinks(args[2]);
        } else {
            followLinks(args[1]);
        }
    }
}
 
main ('%s');
