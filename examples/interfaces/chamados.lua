local aurora = getAurora()

function interface()
    aurora:drawText('Nome', 546, 344, 41, 18, tocolor(241, 241, 241, 255), {name = 'roboto-medium', size = 15}, 'left', 'top', false, false, true)
end

addEventHandler('onClientRender', root, interface);