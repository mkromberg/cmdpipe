 r←Read timeout;⎕RTL
 ⍝ Read pipe to next NL

 ⎕RTL←timeout
 :Repeat r←⎕UCS(,10)PIPE ⎕ARBIN ⍬
   :Until 0≠≢r