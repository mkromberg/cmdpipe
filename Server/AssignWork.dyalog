 r←AssignWork dummy;n
 r←0

 f←{
     (Q m)←⊃TODO[⍵]
     indices←,⍺(⍳⍤1)⊂Q
     iir←indices≤≢¨↓⍺
     index←iir⍳1
     index ⍵
 }

 n←(≢TODO)⌊≢WORKERS
 :If n≠0
     workerTable←↑WORKERS
     workerQs←↑workerTable[;2]

    ⍝ For each in the TODO
    ⍝ get the index if any of the queue
    ⍝ Todo = todo minus where indices ≠ 0
    ⍝ Workers = workers minus unique indices in list
    ⍝ send work to workers

     ⎕←↑WORKERS
     indices←⊆workerQs∘f¨,⍳⍴TODO
     workerIndices←a⍳(unique←∪a←1⌷[2]↑indices)
     {w t←⍵ ⋄ (Q m)←⊃TODO[t] ⋄  ic.Respond (⎕←⊃workerTable[w;]) m}¨(indices)[workerIndices]


     todoIndices←2⌷[2](↑indices)[workerIndices;]

     l←(⍳⍴WORKERS)~⎕←unique
     WORKERS←WORKERS[l]
     TODO←TODO[(⍳⍴TODO)~todoIndices]
     ⎕←WORKERS


 :EndIf

⍝ for each worker send them some work
⍝ :If n≠0
⍝     (ic.Respond⍤1) (n↑WORKERS),⍪n↑TODO
⍝     (WORKERS TODO)←n↓¨WORKERS TODO
⍝ :EndIf
