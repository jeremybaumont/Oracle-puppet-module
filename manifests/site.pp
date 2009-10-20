import "templates.pp"
import "classes/*"
import "groups/*"
import "users/*"

import "oracle"
import "oracle/*.pp"

import "nodes.pp"

filebucket { main: server => puppet }
File { backup => main }


