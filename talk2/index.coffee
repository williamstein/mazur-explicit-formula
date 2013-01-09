#################################
# coffee -c index.coffee
# ###############################
#

class Animation
    constructor: (elt, opts) ->
        @frames = []
        if not opts.fps?
            opts.fps = 1
        @fps = opts.fps
        if not opts.loop?
            opts.loop = false
        @loop = opts.loop
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

    update: (loop_anyways) =>
        m = (@n + 1)%(@frames.length)
        if not loop_anyways? and m == 0 and not @loop
            @stop()
        else
            @frames[@n].replaceWith(@frames[m])
            @n = m

    start: () =>
        if @interval_timer?
            return
        @update(true)
        @interval_timer = setInterval(@update, 1000.0/@fps)

    stop: () =>
        clearInterval(@interval_timer)
        delete @interval_timer

    toggle_running: () =>
        if @interval_timer?
            @stop()
        else
            @start()


$.fn.extend
    animate: (opts={}) ->   # fps, frames (array of filenames), width, height
        if not opts.frames?
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
    #$("#cover-animation").animate
    #    frames : ("svg/test1/#{X}.svg" for X in [100..150])
    #    fps    : 5
    #    loop   : false

    $("section").addClass('slide')
    $("[rel=tooltip]").tooltip
        delay: {show: 1000, hide: 100}
    $(".eq").mathjax(display:true)


    for x in ['raw', 'medium', 'well']
        $("##{x}-defn").hover(
            (() -> $(this).data('conj').show(); $("#conj-inst").hide()),
            (() -> $(this).data('conj').hide(); $("#conj-inst").show())
        ).data("conj", $("##{x}-conj"))


    for x in ["11a", "14a", "37a", "43a", "389a", "433a", "5077a", "11197a"]
        console.log($("#curve-#{x}"))
        $("#curve-#{x}").hover () ->
            label = $(this).attr('id').slice(6)
            console.log("../plots/1e9/#{label}-medium-1000000000.svg")
            plot_raw = $("<img>").attr
                src: "../plots/1e9/#{label}-raw-1000000000.svg"
                width: "100%"
            plot_medium = $("<img>").attr
                src: "../plots/1e9/#{label}-medium-1000000000.svg"
                width : "100%"
            plot_well = $("<img>").attr
                src: "../plots/1e9/#{label}-well-1000000000.svg"
                width : "100%"
            $("#plot-raw").html(plot_raw)
            $("#plot-medium").html(plot_medium)
            $("#plot-well").html(plot_well)

    $(".draggable").draggable()

    f = () ->
        $.deck('.slide')
    MathJax.Hub.Queue(["Typeset",MathJax.Hub])
    MathJax.Hub.Queue(f)
)
