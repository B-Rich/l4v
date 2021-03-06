(*
 * Copyright 2014, General Dynamics C4 Systems
 *
 * This software may be distributed and modified according to the terms of
 * the GNU General Public License version 2. Note that NO WARRANTY is provided.
 * See "LICENSE_GPLv2.txt" for details.
 *
 * @TAG(GD_GPL)
 *)

(*
    Declarations from SEL4.Kernel.FaultHandler
*)

chapter "Function Declarations for Fault Handlers"

theory FaultHandlerDecls_H
imports Structures_H FaultMonad_H
begin

#INCLUDE_HASKELL SEL4/Kernel/FaultHandler.lhs decls_only

end
