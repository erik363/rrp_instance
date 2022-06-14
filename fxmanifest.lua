fx_version 'adamant'
lua54 'yes'

game 'gta5'

description 'RRP instance, email: erik3630@gmail.com'

author 'erik363'

version '1.0.0'

server_scripts {
	'server.lua'
}

client_script 'client.lua'
export 'createObject'

server_export 'enter'
server_export 'leave'
server_export 'join'
server_export 'enterObject'
server_export 'leaveObject'
server_export 'leaveAll'

