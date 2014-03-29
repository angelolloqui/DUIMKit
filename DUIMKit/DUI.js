
//Insert an element if it does not exist
var insertElement = function (id, tag) {
    //            console.log("insert element <"+tag+"> "+id);
    var e = document.getElementById(id);
    if (!e) {
        e = document.createElement(tag);
        e.setAttribute('id', id);
        document.body.appendChild(e);
    }
    return e;
};

//Moves one element from child to new parent
var moveElementToParent = function (id, idParent) {
    var child = document.getElementById(id);
    var parent = document.getElementById(idParent);
    if (!parent) {
        parent = document.body;
    }
    parent.appendChild(child);
};

var computedStyleForProperty = function (id, property) {
//    console.log("Computed style of "+id+":"+property);
    return document.defaultView.getComputedStyle(document.getElementById(id)).getPropertyCSSValue(property);
//    return window.getComputedStyle(document.getElementById(id)).getPropertyCSSValue(property);
}