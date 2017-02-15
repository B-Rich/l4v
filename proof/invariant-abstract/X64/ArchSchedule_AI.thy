(*
 * Copyright 2014, General Dynamics C4 Systems
 *
 * This software may be distributed and modified according to the terms of
 * the GNU General Public License version 2. Note that NO WARRANTY is provided.
 * See "LICENSE_GPLv2.txt" for details.
 *
 * @TAG(GD_GPL)
 *)

theory ArchSchedule_AI
imports "../Schedule_AI"
begin

context Arch begin global_naming X64

named_theorems Schedule_AI_asms

lemma dmo_mapM_storeWord_0_invs[wp,Schedule_AI_asms]:
  "valid invs (do_machine_op (mapM (\<lambda>p. storeWord p 0) S)) (\<lambda>_. invs)"
  apply (simp add: dom_mapM ef_storeWord)
  apply (rule mapM_UNIV_wp)
  apply (simp add: do_machine_op_def split_def)
  apply wp
  apply (clarsimp simp: invs_def valid_state_def cur_tcb_def
                        valid_machine_state_def)
  apply (rule conjI)
   apply(erule use_valid[OF _ storeWord_valid_irq_states], simp)
  apply (erule use_valid)
   apply (simp add: storeWord_def word_rsplit_0)
   apply wp
  apply (simp add: upto0_7_def split: if_splits)
  done
  
global_naming Arch  

lemma arch_stt_invs [wp,Schedule_AI_asms]:
  "\<lbrace>invs\<rbrace> arch_switch_to_thread t' \<lbrace>\<lambda>_. invs\<rbrace>"
  apply (simp add: arch_switch_to_thread_def)
  apply wp
  done  

lemma arch_stt_tcb [wp,Schedule_AI_asms]:
  "\<lbrace>tcb_at t'\<rbrace> arch_switch_to_thread t' \<lbrace>\<lambda>_. tcb_at t'\<rbrace>"
  apply (simp add: arch_switch_to_thread_def) 
  apply (wp)
  done
  
lemma arch_stt_runnable[Schedule_AI_asms]:
  "\<lbrace>st_tcb_at runnable t\<rbrace> arch_switch_to_thread t \<lbrace>\<lambda>r . st_tcb_at runnable t\<rbrace>"
  apply (simp add: arch_switch_to_thread_def)
  apply wp
  done  
  
lemma stit_invs [wp,Schedule_AI_asms]:
  "\<lbrace>invs\<rbrace> switch_to_idle_thread \<lbrace>\<lambda>rv. invs\<rbrace>"
  apply (simp add: switch_to_idle_thread_def arch_switch_to_idle_thread_def)
  apply wp
  apply (clarsimp simp: invs_def valid_state_def valid_idle_def pred_tcb_at_tcb_at)
  apply (clarsimp simp: in_user_frame_def valid_arch_state_def valid_machine_state_def cur_tcb_def)
  apply (clarsimp simp: obj_at_def pred_tcb_at_def is_tcb)
  done
  
lemma stit_activatable[Schedule_AI_asms]:
  "\<lbrace>invs\<rbrace> switch_to_idle_thread \<lbrace>\<lambda>rv . ct_in_state activatable\<rbrace>"
  apply (simp add: switch_to_idle_thread_def arch_switch_to_idle_thread_def)
  apply (wp | simp add: ct_in_state_def)+
  apply (clarsimp simp: invs_def valid_state_def cur_tcb_def valid_idle_def
                 elim!: pred_tcb_weaken_strongerE)
  done  

lemma stt_invs [wp,Schedule_AI_asms]:
  "\<lbrace>invs\<rbrace> switch_to_thread t' \<lbrace>\<lambda>_. invs\<rbrace>"
  apply (simp add: switch_to_thread_def)
  apply wp
     apply (simp add: trans_state_update[symmetric] del: trans_state_update)
    apply (rule_tac Q="\<lambda>_. invs and tcb_at t'" in hoare_strengthen_post, wp)
    apply (clarsimp simp: invs_def valid_state_def valid_idle_def
                          valid_irq_node_def valid_machine_state_def)
    apply (fastforce simp: cur_tcb_def obj_at_def
                     elim: valid_pspace_eqI ifunsafe_pspaceI)
   apply (wp)
   apply (rule get_wp) (* FIXME x64: WTF? *)
  apply clarsimp
  apply (simp add: is_tcb_def)
  done
end

interpretation Schedule_AI_U?: Schedule_AI_U
  proof goal_cases
  interpret Arch .
  case 1 show ?case 
  by (intro_locales; (unfold_locales; fact Schedule_AI_asms)?) 
  qed

interpretation Schedule_AI?: Schedule_AI
  proof goal_cases
  interpret Arch .
  case 1 show ?case 
  by (intro_locales; (unfold_locales; fact Schedule_AI_asms)?) 
  qed

end