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
            element = t.html(tex)
            MathJax.Hub.Queue(["Typeset", MathJax.Hub, element[0]])

$(() ->
    $("section").addClass('slide')
    $("[rel=tooltip]").tooltip
        delay: {show: 1000, hide: 100}
    $(".eq").mathjax(display:true)

    for x in ['raw', 'medium', 'well']
        $("##{x}-defn").hover(
            (() -> $(this).data('conj').show(); $("#conj-inst").hide()),
            (() -> $(this).data('conj').hide(); $("#conj-inst").show())
        ).data("conj", $("##{x}-conj"))

    $(".draggable").draggable()

    f = () ->
        $.deck('.slide')
    MathJax.Hub.Queue(["Typeset",MathJax.Hub])
    MathJax.Hub.Queue(f)
)
