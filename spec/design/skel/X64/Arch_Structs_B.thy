(*
 * Copyright 2014, General Dynamics C4 Systems
 *
 * This software may be distributed and modified according to the terms of
 * the GNU General Public License version 2. Note that NO WARRANTY is provided.
 * See "LICENSE_GPLv2.txt" for details.
 *
 * @TAG(GD_GPL)
 *)

(* Architecture-specific data types shared by spec and abstract. *)

chapter "Common, Architecture-Specific Data Types"

theory Arch_Structs_B
imports "~~/src/HOL/Main" "../../../spec/machine/$L4V_ARCH/Setup_Locale"
begin
(* FIXME: Clagged from ARM version *)

context Arch begin global_naming X64_H

#INCLUDE_HASKELL SEL4/Model/StateData/X64.lhs CONTEXT X64 ONLY ArmVSpaceRegionUse

end (* context X64 *)

end