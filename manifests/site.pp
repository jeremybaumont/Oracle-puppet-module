import "templates.pp"
import "nodes.pp"
import "classes/*"
import "groups/*"
import "users/*"
#import "os/*"

filebucket { main: server => puppet }
File { backup => main }


