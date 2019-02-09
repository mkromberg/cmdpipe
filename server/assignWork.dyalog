 r←assignWork dummy;n
 n←(≢TODO)⌊≢WORKERS
⍝ for each worker send them some work
 :If n≠0
     (ic.Respond⍤1) (n↑WORKERS),⍪n↑TODO
     (WORKERS TODO)←n↓¨WORKERS TODO
     r←n' workers assigned work'
 :EndIf
