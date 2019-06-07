!function n(){var o=document.querySelector("video");null!=o?(o.removeAttribute("autoplay"),o.onplay=function(){o.pause(),o.onplay=function(){}}):setTimeout(function(){n()},100)}();
