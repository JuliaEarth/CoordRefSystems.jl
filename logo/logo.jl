# Logo script adapted from cormullion's code
# link: https://gist.github.com/cormullion/2a536d562aa4e7e4557daba8d6b4619e

using Thebes
using Luxor
using Rotations
using Colors

julia_colors = [Luxor.julia_red, Luxor.julia_purple, Luxor.julia_blue, Luxor.julia_green]

function draw_check_line(fp, tp, divs, width)
  @layer begin
    rotate(slope(fp, tp))
    D = distance(fp, tp) / divs
    for n in 1:divs
      spos = Point(fp.x + (n - 1) * D, fp.y)
      epos = spos + (D, width)
      if isodd(n)
        sethue("black")
        # corner to corner
        box(spos, epos, :fill)
      else
        # white boxes aren't drawn using lines!
        sethue("black")
        box(spos, epos, :fill)
        sethue("white")
        box(spos + (3, 3), epos - (3, 3), :fill)
      end
    end
  end
end

function cursor(pos, radius)
  thickness = 15 # equivalent to line width
  l = radius / 2 # length of shape running from edge towards center 
  @layer begin
    sethue("white")
    translate(pos)
    circlepath(O, radius, :path)
    circlepath(O, radius - thickness, reversepath=true, :path)
    fillpath()
    for (i, θ) in enumerate(range(0, step=π / 2, length=4))
      @layer begin
        translate(polar(radius, θ))
        rotate(θ)
        box(O + (0, -thickness / 2), O + (-l, thickness / 2), :fill)
      end
    end
  end
end

function render_sphere(o::Object)
  @layer begin
    dots = Set{Point}()
    if !isempty(o.faces)
      sortfaces!(o)
      for (n, face) in enumerate(o.faces)
        @layer begin
          vertices = o.vertices[face]
          sn = surfacenormal(vertices)
          ang = anglebetweenvectors(sn, eyepoint())
          if ang < π / 2
            pin(vertices, gfunction=(p3, p2) -> begin
              sethue(LCHab(30, 50, 290))
              poly(p2, :fill, close=true)
              sethue("grey60")
              poly(p2, :stroke, close=true)
              for pt in p2
                if distance(O, pt) < 130
                  push!(dots, pt)
                end
              end
            end)
          end
        end
      end
    end
    # mark the junctions with dots
    sethue("grey70")
    circle.(dots, 5, :fill)
  end
end

function cartography(s)
  Δ = s / 600 # scale factor, original design was 600units
  scale(Δ)

  # background
  squircle(O, 240, 240, rt=0.2, :clip)
  sethue(LCHab(20, 30, 290))
  paint()
  tiles = Tiler(400, 400, 6, 6)
  for (pos, n) in tiles
    sethue("grey80")
    box(pos, tiles.tilewidth, tiles.tileheight, :clip)
    box(pos, tiles.tilewidth + 2, tiles.tileheight + 2, :path)
    box(pos, tiles.tilewidth - 5, tiles.tileheight - 5, :path, reversepath=true)
    fillpath()
    clipreset()
  end
  clipreset()

  # Julia-colored border
  squircle(O, 240, 240, rt=0.2, :path)
  box(O, 380, 380, reversepath=true, :path)
  clip()
  for (i, θ) in enumerate(range(0, step=π / 2, length=4))
    sethue(julia_colors[mod1(i, end)])
    sector(O, 200, 350, θ - π / 4, θ + π / 4, :fill)
  end
  clipreset()

  # black and white borders
  for θ in range(0, 2π, step=π / 2)
    @layer begin
      rotate(θ)
      draw_check_line(O + (-190, 190), O + (190, 190), 8, 15)
    end
  end

  # wireframe sphere 
  # read sphere data from file
  eyepoint(150, 150, 200)
  perspective(700)
  include(dirname(dirname(pathof(Thebes))) * "/data/sphere.jl")
  include(dirname(dirname(pathof(Thebes))) * "/data/moreobjects.jl")
  S = make(sphere, "a sphere")
  scaleby!(S, 120)
  rotateby!(S, RotX(π / 2))
  rotateby!(S, RotY(-π / 5))
  # don't want all of the sphere
  circle(O, 130, :clip)
  pin(S, gfunction=render_sphere)
  clipreset()

  # the cursor-like shape
  cursor(O, 140)
end

function logo(s, fname)
  Drawing(s, s, fname)
  origin()
  cartography(s)
  finish()
  preview()
end

function logotext(w, h, fname)
  Drawing(w, h, fname)
  origin()
  table = Table([h], [h, w - h])
  @layer begin
    translate(table[2])
    background("white")
    sethue("black")
    # find all fonts available on Linux with `fc-list | -f 2 -d ":"`
    fontface("Julius Sans One")
    fontsize(h / 2.5)
    text("Cartography.jl", halign=:center, valign=:middle)
  end
  @layer begin
    translate(table[1])
    cartography(h)
  end
  finish()
  preview()
end

logo(240, joinpath(@__DIR__, "logo.svg"))
logotext(880, 200, joinpath(@__DIR__, "logo-text.svg"))
