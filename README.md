# cmdpipe
APL processor for commands arriving on a fifo / pipe

## Basic functionality so far:
Start a server
```
]link.import # 'path\to\cmdpipe\Server'
#.Main #.Make <port_number>
```

With the server listening, start a worker (functionality will be moved to ADMIN)
```
]link.import # 'path\to\cmdpipe'
⍝ default queue name is DEFAULT
⍝ queue names are optional
#.client.Main (⊂'list' 'of' 'queue' 'names'),#.Utils.makeClient <ip_address_Server> <port_Server>
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


