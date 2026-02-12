fx_version 'bodacious'
games { 'gta5', 'rdr3' }
version '0.1.0'
author 'maku#5434 (itismaku)'

client_script 'client/cl-events.lua'

server_script 'server/sv-events.lua'

ui_page 'client/cl-index.html'

files {
    'client/cl-index.html',
    'client/cl-fetch.js'
}
