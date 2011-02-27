(*
 * events.ml
 * ---------
 * Copyright : (c) 2011, Jeremie Dimino <jeremie@dimino.org>
 * Licence   : BSD3
 *
 * This file is a part of Lambda-Term.
 *)

(* Show events read from the terminal *)

open Lwt
open Lt_event

let rec loop term =
  lwt ev = term#read_event in
  lwt () = Lwt_io.printl (Lt_event.to_string ev) in
  match ev with
    | Lt_event.Key{ Lt_key.code = Lt_key.Escape } ->
        return ()
    | _ ->
        loop term

lwt () =
  lwt () = Lwt_io.printl "press escape to exit" in
  lwt () = Lt_term.stdout#enter_raw_mode in
  lwt () = Lt_term.stdout#enter_mouse_mode in
  try_lwt
    loop Lt_term.stdout
  finally
    lwt () = Lt_term.stdout#leave_mouse_mode in
    Lt_term.stdout#leave_raw_mode
