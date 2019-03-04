 r←makeClient (ip port QNames);ic;client;code;name

 :If 0=⎕NC'Conga'
   'Conga'⎕CY'conga'
 :EndIf

 ic←Conga.Init ''
 client←ic.Clt '' ip port 'Command' 
 code name←2↑client

 :If code≠0
   ('Error starting client: ', ⍕client) ⎕SIGNAL 700
 :EndIf

 r←ic name QNames
