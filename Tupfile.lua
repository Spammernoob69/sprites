
-- Generate uniform size minisprites

for canon in iter{"canonical", "noncanonical"} do 
    for dir in iter{"asymmetrical", "custom", "misc", "pokemon"} do
        -- TODO fix this, tup hates git's quirk of not creating directories when
        -- there aren't any files
        if canon == "noncanonical" and dir ~= "pokemon" then
            goto continue
        end

        tup.foreach_rule(
            rep{"src/{canon}/minisprites/gen6/{dir}/*", canon=canon, dir=dir},
            "^ pad g6 minisprite %f^ " .. pad(40, 30, "%f", "%o"),
            rep{"build/gen6-minisprites-padded/{canon}/{dir}/%b",canon=canon,dir=dir}
        )
        
        ::continue::
    end
end

-- PS spritesheet

tup.rule(
    {"build/gen6-minisprites-padded/canonical/pokemon/*", "build/gen6-minisprites-padded/noncanonical/pokemon/*"},
    "node tools/sprites/ps.js build/gen6-minisprites-padded/canonical/pokemon/ build/gen6-minisprites-padded/noncanonical/pokemon/ --output-image build/ps/pokemonicons-sheet.png --output-metadata build/ps/pokemonicons.json",
    {"build/ps/pokemonicons-sheet.png", "build/ps/pokemonicons.json"}
)

-- Smogdex social images

function fbsprite(input, output)
    tup.foreach_rule(
        input,
        "^ fbsprite %f^ tools/fbsprite.sh %f %o",
        output
    )
end

function twittersprite(input, output)
    tup.foreach_rule(
        input,
        "^ twittersprite %f^ tools/twittersprite.sh %f %o",
        output
    )
end

local files =
    {"src/canonical/models/front/*", "src/noncanonical/models/front/*",
     -- TODO: only pick noncanonical that aren't already in models/
     "src/noncanonical/sprites/gen5/front/*"}

fbsprite(files, "build/smogon/fbsprites/xy/%B.png")
twittersprite(files, "build/smogon/twittersprites/xy/%B.png")

-- Trainers

tup.foreach_rule(
    {"src/canonical/trainers/*"},
    "^ pad trainer %f^ " .. makecmd{pad(80, 80, "%f", "%o"), compresspng("%f",  {})},
    {"build/padded-trainers/canonical/%b"}
)

-- Padded Dex

for dir in iter{"front", "front-cosmetic", "front-shiny", "front-shiny-cosmetic"} do
    tup.foreach_rule(
        rep{"src/canonical/dex/{dir}/*", dir=dir},
        "^ pad dex %f^ " .. makecmd{pad(120, 120, "%f", "%o"), compresspng("%f",  {})},
        rep{"build/padded-dex/canonical/{dir}/%b", dir=dir}
    )
end
