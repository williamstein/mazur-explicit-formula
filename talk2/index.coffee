#################################
# coffee -c index.coffee
# ###############################

# jquery plugin:

$.fn.extend
    mathjax: (opts={}) ->
        if not opts.display?
            opts.display=true
        @each () ->
            t = $(this)
            tex = t.html()
            if opts.display
                tex = "$${#{tex}}$$"
            else
                tex = "\\({#{tex}}\\)"
            element = t.text(tex)
            MathJax.Hub.Queue(["Typeset", MathJax.Hub, element[0]])

$(() ->
    $(".eq").mathjax(display:true)
    $("section").addClass('slide')
    $.deck('.slide')
)
