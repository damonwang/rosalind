let synchronous =
  [ (module Dna.Sync : Synchronous_intf.S)
  ; (module Rna.Sync : Synchronous_intf.S)
  ; (module Revc.Sync : Synchronous_intf.S)
  ; (module Gc_content.Sync : Synchronous_intf.S)
  ; (module Hamm.Sync : Synchronous_intf.S)
  ; (module Prot.Sync : Synchronous_intf.S)
  ]
