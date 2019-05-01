# cmdpipe
### Description:
APL Task management system. Receive tasks via socket, and distribute them accross workers.

### Prerequisites:
This project depends on the most common APLCore library, and Link library
https://github.com/Dyalog/library-core
https://github.com/Dyalog/link

### Usage:
Start a server
```
]link.import # 'path\to\cmdpipe\Server'
#.Main #.Make <port_number>
```

With the server listening, start a worker 
```
]link.import # 'path\to\cmdpipe'
⍝ default queue name is DEFAULT
⍝ queue names are optional
#.Admin.Main #.Utils.makeClient <ip_address_Server> <port_Server>

⍝ Admin prompt should appear awaiting input
admin>

⍝ Example: dir path to cmdpipe, ip address of server relative to worker, port number of server
⍝ qs is a double quoted string of comma separated values. no spaces
admin> startworker dir=D:\dyalog\cmdpipe ip=127.0.0.1 port=3500 qs="blah,bleh,bluh"
```

The worker is now listening for tasks.

Create a task (for testing only)
```
clientName ← 'test'
aplCode    ← '1+1'
'Conga'⎕CY'conga'
ic←Conga.Init''
client ← ic.Clt clientName <ip_server> <port_server> 'Command'

⍝ Repeat this line as many times as necessary
ic.Send clientName ('FIFO' ('qName' aplCode))
```

### Admin Commands

There are 2 main command types: `worker` and `task`
Below are a list of commands with example arguments
```
⍝ start a worker
⍝ dir takes the path of the cmdpipe dir on the server
⍝ the ip of the server relative to the worker
⍝ the port of the running server
⍝ the qnames, tells the server what QS a worker is allowed to process. Comma Separated, no spaces
admin> worker start dir=<server cmdpipe dir> ip=<server ip> port=<server port> qs="<comma separated qNames"

⍝ retrieve information about the worker
admin> worker info

⍝ retrieve current status of worker
admin> worker status

    
