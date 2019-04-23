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



