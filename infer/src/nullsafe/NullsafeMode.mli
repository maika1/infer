(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd

(** Represents a type-checking mode of nullsafe. *)

module Trust : sig
  [@@@warning "-32"]

  type t = All | Only of Typ.name list [@@deriving compare, equal]

  val none : t

  val of_annot : Annot.t -> t option
  (** Returns [Trust.t] when provided annotation matches the format of [@TrustList], otherwise
      [None]. *)

  val pp : Format.formatter -> t -> unit
end

type t = Default | Local of Trust.t | Strict [@@deriving compare, equal]

val of_annot : Annot.t -> t option
  [@@warning "-32"]
(** Returns [t] when provided annotation matches the format of [@Nullsafe], otherwise [None]. *)

val of_class : Tenv.t -> Typ.name -> t
(** Extracts mode information from class annotations *)

val of_procname : Tenv.t -> Procname.t -> t
(** Extracts mode information from a class where procname is defined *)

val is_trusted_name : t -> Typ.name -> bool
(** Check whether [Typ.name] can be trusted under a given mode *)

val severity : t -> Exceptions.severity
(** Provides a default choice of issue severity for a particular mode. Rule is: severity should be
    ERROR if and only if it is enforced. *)

val pp : Format.formatter -> t -> unit
