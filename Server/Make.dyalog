 r←Make port
 ⍝ Simply call with a port number

 :If 0=⎕NC'Conga'
   'Conga'⎕CY'conga'
 :EndIf

 ic←Conga.Init ''
 server←ic.Srv '' '' port 'Command' 
 code name←2↑server

 :If code≠0
   ('Error starting client: ', ⍕server) ⎕SIGNAL 700
 :EndIf

 r←ic name
