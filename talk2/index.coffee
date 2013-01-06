#################################
# coffee -c index.coffee
# ###############################
#

class Animation
    constructor: (elt, opts) ->
        @running = false
        @frames = []
        if not opts.fps?
            opts.fps = 1
        @fps = opts.fps
        for frame in opts.frames
            img = $("<img>").attr("src",frame)
            if opts.width?
                img.attr("width", opts.width)
            if opts.height?
                img.attr("height", opts.height)
            @frames.push(img)
        @n = 0
        elt.append(@frames[0])
        elt.attr("rel","tooltip").attr("title", " Click to animate ").tooltip()
        elt.click(@toggle_running)

    update: () =>
        m = (@n + 1)%(@frames.length)
        @frames[@n].replaceWith(@frames[m])
        @n = m

    start: () =>
        console.log('start')
        if @running
            return
        @running = true
        @interval_timer = setInterval(@update, 1000.0/@fps)

    stop: () =>
        console.log('stop')
        if not @running
            return
        @running = false
        clearInterval(@interval_timer)

    toggle_running: () =>
        if @running
            @stop()
        else
            @start()


$.fn.extend
    animate: (opts={}) ->   # fps, frames (array of filenames), width, height
        if not opts.frames?
            console.log("Empty animation?")
            return  # no point!
        @each () ->
            ani = new Animation($(this), opts)


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
    $("#cover-animation").animate
        frames:['svg/delta_E-11a1-step-1000.svg', 'svg/delta_E-32a1-1000000.svg']

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
