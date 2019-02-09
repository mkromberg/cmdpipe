 r←Read timeout;⎕RTL
 ⍝ Read pipe to next NL

 ⎕RTL←timeout
 r←⎕UCS(,10)PIPE ⎕ARBIN ⍬
