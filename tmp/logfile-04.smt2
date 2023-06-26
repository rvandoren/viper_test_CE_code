(get-info :version)
; (:version "4.8.7")
; Started: 2023-05-08 14:40:50
; Silicon.version: 1.1-SNAPSHOT (7f2e6823@(detached))
; Input file: <unknown>
; Verifier id: 00
; ------------------------------------------------------------
; Begin preamble
; ////////// Static preamble
; 
; ; /z3config.smt2
(set-option :print-success true) ; Boogie: false
(set-option :global-decls true) ; Boogie: default
(set-option :auto_config false) ; Usually a good idea
(set-option :smt.restart_strategy 0)
(set-option :smt.restart_factor |1.5|)
(set-option :smt.case_split 3)
(set-option :smt.delay_units true)
(set-option :smt.delay_units_threshold 16)
(set-option :nnf.sk_hack true)
(set-option :type_check true)
(set-option :smt.bv.reflect true)
(set-option :smt.mbqi false)
(set-option :smt.qi.eager_threshold 100)
(set-option :smt.qi.cost "(+ weight generation)")
(set-option :smt.qi.max_multi_patterns 1000)
(set-option :smt.phase_selection 0) ; default: 3, Boogie: 0
(set-option :sat.phase caching)
(set-option :sat.random_seed 0)
(set-option :nlsat.randomize true)
(set-option :nlsat.seed 0)
(set-option :nlsat.shuffle_vars false)
(set-option :fp.spacer.order_children 0) ; Not available with Z3 4.5
(set-option :fp.spacer.random_seed 0) ; Not available with Z3 4.5
(set-option :smt.arith.random_initial_value true) ; Boogie: true
(set-option :smt.random_seed 0)
(set-option :sls.random_offset true)
(set-option :sls.random_seed 0)
(set-option :sls.restart_init false)
(set-option :sls.walksat_ucb true)
(set-option :model.v2 true)
; 
; ; /preamble.smt2
(declare-datatypes (($Snap 0)) ((
    ($Snap.unit)
    ($Snap.combine ($Snap.first $Snap) ($Snap.second $Snap)))))
(declare-sort $Ref 0)
(declare-const $Ref.null $Ref)
(declare-sort $FPM 0)
(declare-sort $PPM 0)
(define-sort $Perm () Real)
(define-const $Perm.Write $Perm 1.0)
(define-const $Perm.No $Perm 0.0)
(define-fun $Perm.isValidVar ((p $Perm)) Bool
	(<= $Perm.No p))
(define-fun $Perm.isReadVar ((p $Perm)) Bool
    (and ($Perm.isValidVar p)
         (not (= p $Perm.No))))
(define-fun $Perm.min ((p1 $Perm) (p2 $Perm)) Real
    (ite (<= p1 p2) p1 p2))
(define-fun $Math.min ((a Int) (b Int)) Int
    (ite (<= a b) a b))
(define-fun $Math.clip ((a Int)) Int
    (ite (< a 0) 0 a))
; ////////// Sorts
(declare-sort Set<$Ref> 0)
(declare-sort Set<Int> 0)
(declare-sort Set<$Snap> 0)
(declare-sort $FVF<first> 0)
(declare-sort $FVF<second> 0)
(declare-sort $FVF<val> 0)
; ////////// Sort wrappers
; Declaring additional sort wrappers
(declare-fun $SortWrappers.IntTo$Snap (Int) $Snap)
(declare-fun $SortWrappers.$SnapToInt ($Snap) Int)
(assert (forall ((x Int)) (!
    (= x ($SortWrappers.$SnapToInt($SortWrappers.IntTo$Snap x)))
    :pattern (($SortWrappers.IntTo$Snap x))
    :qid |$Snap.$SnapToIntTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.IntTo$Snap($SortWrappers.$SnapToInt x)))
    :pattern (($SortWrappers.$SnapToInt x))
    :qid |$Snap.IntTo$SnapToInt|
    )))
(declare-fun $SortWrappers.BoolTo$Snap (Bool) $Snap)
(declare-fun $SortWrappers.$SnapToBool ($Snap) Bool)
(assert (forall ((x Bool)) (!
    (= x ($SortWrappers.$SnapToBool($SortWrappers.BoolTo$Snap x)))
    :pattern (($SortWrappers.BoolTo$Snap x))
    :qid |$Snap.$SnapToBoolTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.BoolTo$Snap($SortWrappers.$SnapToBool x)))
    :pattern (($SortWrappers.$SnapToBool x))
    :qid |$Snap.BoolTo$SnapToBool|
    )))
(declare-fun $SortWrappers.$RefTo$Snap ($Ref) $Snap)
(declare-fun $SortWrappers.$SnapTo$Ref ($Snap) $Ref)
(assert (forall ((x $Ref)) (!
    (= x ($SortWrappers.$SnapTo$Ref($SortWrappers.$RefTo$Snap x)))
    :pattern (($SortWrappers.$RefTo$Snap x))
    :qid |$Snap.$SnapTo$RefTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$RefTo$Snap($SortWrappers.$SnapTo$Ref x)))
    :pattern (($SortWrappers.$SnapTo$Ref x))
    :qid |$Snap.$RefTo$SnapTo$Ref|
    )))
(declare-fun $SortWrappers.$PermTo$Snap ($Perm) $Snap)
(declare-fun $SortWrappers.$SnapTo$Perm ($Snap) $Perm)
(assert (forall ((x $Perm)) (!
    (= x ($SortWrappers.$SnapTo$Perm($SortWrappers.$PermTo$Snap x)))
    :pattern (($SortWrappers.$PermTo$Snap x))
    :qid |$Snap.$SnapTo$PermTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$PermTo$Snap($SortWrappers.$SnapTo$Perm x)))
    :pattern (($SortWrappers.$SnapTo$Perm x))
    :qid |$Snap.$PermTo$SnapTo$Perm|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.Set<$Ref>To$Snap (Set<$Ref>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<$Ref> ($Snap) Set<$Ref>)
(assert (forall ((x Set<$Ref>)) (!
    (= x ($SortWrappers.$SnapToSet<$Ref>($SortWrappers.Set<$Ref>To$Snap x)))
    :pattern (($SortWrappers.Set<$Ref>To$Snap x))
    :qid |$Snap.$SnapToSet<$Ref>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<$Ref>To$Snap($SortWrappers.$SnapToSet<$Ref> x)))
    :pattern (($SortWrappers.$SnapToSet<$Ref> x))
    :qid |$Snap.Set<$Ref>To$SnapToSet<$Ref>|
    )))
(declare-fun $SortWrappers.Set<Int>To$Snap (Set<Int>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Int> ($Snap) Set<Int>)
(assert (forall ((x Set<Int>)) (!
    (= x ($SortWrappers.$SnapToSet<Int>($SortWrappers.Set<Int>To$Snap x)))
    :pattern (($SortWrappers.Set<Int>To$Snap x))
    :qid |$Snap.$SnapToSet<Int>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Int>To$Snap($SortWrappers.$SnapToSet<Int> x)))
    :pattern (($SortWrappers.$SnapToSet<Int> x))
    :qid |$Snap.Set<Int>To$SnapToSet<Int>|
    )))
(declare-fun $SortWrappers.Set<$Snap>To$Snap (Set<$Snap>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<$Snap> ($Snap) Set<$Snap>)
(assert (forall ((x Set<$Snap>)) (!
    (= x ($SortWrappers.$SnapToSet<$Snap>($SortWrappers.Set<$Snap>To$Snap x)))
    :pattern (($SortWrappers.Set<$Snap>To$Snap x))
    :qid |$Snap.$SnapToSet<$Snap>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<$Snap>To$Snap($SortWrappers.$SnapToSet<$Snap> x)))
    :pattern (($SortWrappers.$SnapToSet<$Snap> x))
    :qid |$Snap.Set<$Snap>To$SnapToSet<$Snap>|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.$FVF<first>To$Snap ($FVF<first>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<first> ($Snap) $FVF<first>)
(assert (forall ((x $FVF<first>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<first>($SortWrappers.$FVF<first>To$Snap x)))
    :pattern (($SortWrappers.$FVF<first>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<first>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<first>To$Snap($SortWrappers.$SnapTo$FVF<first> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<first> x))
    :qid |$Snap.$FVF<first>To$SnapTo$FVF<first>|
    )))
(declare-fun $SortWrappers.$FVF<second>To$Snap ($FVF<second>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<second> ($Snap) $FVF<second>)
(assert (forall ((x $FVF<second>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<second>($SortWrappers.$FVF<second>To$Snap x)))
    :pattern (($SortWrappers.$FVF<second>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<second>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<second>To$Snap($SortWrappers.$SnapTo$FVF<second> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<second> x))
    :qid |$Snap.$FVF<second>To$SnapTo$FVF<second>|
    )))
(declare-fun $SortWrappers.$FVF<val>To$Snap ($FVF<val>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<val> ($Snap) $FVF<val>)
(assert (forall ((x $FVF<val>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<val>($SortWrappers.$FVF<val>To$Snap x)))
    :pattern (($SortWrappers.$FVF<val>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<val>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<val>To$Snap($SortWrappers.$SnapTo$FVF<val> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<val> x))
    :qid |$Snap.$FVF<val>To$SnapTo$FVF<val>|
    )))
; ////////// Symbols
(declare-fun Set_in ($Ref Set<$Ref>) Bool)
(declare-fun Set_card (Set<$Ref>) Int)
(declare-const Set_empty Set<$Ref>)
(declare-fun Set_singleton ($Ref) Set<$Ref>)
(declare-fun Set_unionone (Set<$Ref> $Ref) Set<$Ref>)
(declare-fun Set_union (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_disjoint (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_difference (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_intersection (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_subset (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_equal (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_in (Int Set<Int>) Bool)
(declare-fun Set_card (Set<Int>) Int)
(declare-const Set_empty Set<Int>)
(declare-fun Set_singleton (Int) Set<Int>)
(declare-fun Set_unionone (Set<Int> Int) Set<Int>)
(declare-fun Set_union (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_disjoint (Set<Int> Set<Int>) Bool)
(declare-fun Set_difference (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_intersection (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_subset (Set<Int> Set<Int>) Bool)
(declare-fun Set_equal (Set<Int> Set<Int>) Bool)
(declare-fun Set_in ($Snap Set<$Snap>) Bool)
(declare-fun Set_card (Set<$Snap>) Int)
(declare-const Set_empty Set<$Snap>)
(declare-fun Set_singleton ($Snap) Set<$Snap>)
(declare-fun Set_unionone (Set<$Snap> $Snap) Set<$Snap>)
(declare-fun Set_union (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_disjoint (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Set_difference (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_intersection (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_subset (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Set_equal (Set<$Snap> Set<$Snap>) Bool)
; /field_value_functions_declarations.smt2 [first: Ref]
(declare-fun $FVF.domain_first ($FVF<first>) Set<$Ref>)
(declare-fun $FVF.lookup_first ($FVF<first> $Ref) $Ref)
(declare-fun $FVF.after_first ($FVF<first> $FVF<first>) Bool)
(declare-fun $FVF.loc_first ($Ref $Ref) Bool)
(declare-fun $FVF.perm_first ($FPM $Ref) $Perm)
(declare-const $fvfTOP_first $FVF<first>)
; /field_value_functions_declarations.smt2 [second: Ref]
(declare-fun $FVF.domain_second ($FVF<second>) Set<$Ref>)
(declare-fun $FVF.lookup_second ($FVF<second> $Ref) $Ref)
(declare-fun $FVF.after_second ($FVF<second> $FVF<second>) Bool)
(declare-fun $FVF.loc_second ($Ref $Ref) Bool)
(declare-fun $FVF.perm_second ($FPM $Ref) $Perm)
(declare-const $fvfTOP_second $FVF<second>)
; /field_value_functions_declarations.smt2 [val: Int]
(declare-fun $FVF.domain_val ($FVF<val>) Set<$Ref>)
(declare-fun $FVF.lookup_val ($FVF<val> $Ref) Int)
(declare-fun $FVF.after_val ($FVF<val> $FVF<val>) Bool)
(declare-fun $FVF.loc_val (Int $Ref) Bool)
(declare-fun $FVF.perm_val ($FPM $Ref) $Perm)
(declare-const $fvfTOP_val $FVF<val>)
; Declaring symbols related to program functions (from program analysis)
(declare-fun address ($Snap Int) $Ref)
(declare-fun address%limited ($Snap Int) $Ref)
(declare-fun address%stateless (Int) Bool)
(declare-fun address%precondition ($Snap Int) Bool)
; Snapshot variable to be used during function verification
(declare-fun s@$ () $Snap)
; Declaring predicate trigger functions
; ////////// Uniqueness assumptions from domains
; ////////// Axioms
(assert (forall ((s Set<$Ref>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Ref]_prog.card_non_negative|)))
(assert (forall ((e $Ref)) (!
  (not (Set_in e (as Set_empty  Set<$Ref>)))
  :pattern ((Set_in e (as Set_empty  Set<$Ref>)))
  :qid |$Set[Ref]_prog.in_empty_set|)))
(assert (forall ((s Set<$Ref>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<$Ref>)))
    (=>
      (not (= (Set_card s) 0))
      (exists ((e $Ref)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Ref]_prog.empty_set_cardinality|)))
(assert (forall ((e $Ref)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Ref]_prog.in_singleton_set|)))
(assert (forall ((e1 $Ref) (e2 $Ref)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Ref]_prog.in_singleton_set_equality|)))
(assert (forall ((e $Ref)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Ref]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Ref]_prog.in_unionone_same|)))
(assert (forall ((s Set<$Ref>) (e1 $Ref) (e2 $Ref)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Ref]_prog.in_unionone_other|)))
(assert (forall ((s Set<$Ref>) (e1 $Ref) (e2 $Ref)) (!
  (=> (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Ref]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (=> (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Ref]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (=> (not (Set_in e s)) (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Ref]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Ref]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (=> (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Ref]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (=> (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Ref]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Ref]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Ref]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Ref]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Ref]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Ref]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Ref]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Ref]_prog.in_difference|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (=> (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Ref]_prog.not_in_difference|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e $Ref)) (!
      (=> (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Ref]_prog.subset_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e $Ref)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Ref]_prog.equality_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=> (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Ref]_prog.native_equality|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e $Ref)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Ref]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Ref]_prog.cardinality_difference|)))
(assert (forall ((s Set<Int>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Int]_prog.card_non_negative|)))
(assert (forall ((e Int)) (!
  (not (Set_in e (as Set_empty  Set<Int>)))
  :pattern ((Set_in e (as Set_empty  Set<Int>)))
  :qid |$Set[Int]_prog.in_empty_set|)))
(assert (forall ((s Set<Int>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Int>)))
    (=>
      (not (= (Set_card s) 0))
      (exists ((e Int)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Int]_prog.empty_set_cardinality|)))
(assert (forall ((e Int)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Int]_prog.in_singleton_set|)))
(assert (forall ((e1 Int) (e2 Int)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Int]_prog.in_singleton_set_equality|)))
(assert (forall ((e Int)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Int]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Int]_prog.in_unionone_same|)))
(assert (forall ((s Set<Int>) (e1 Int) (e2 Int)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Int]_prog.in_unionone_other|)))
(assert (forall ((s Set<Int>) (e1 Int) (e2 Int)) (!
  (=> (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Int]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (=> (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Int]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (=> (not (Set_in e s)) (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Int]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Int]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (=> (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Int]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (=> (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Int]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Int]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Int]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Int]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Int]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Int]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Int]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Int]_prog.in_difference|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (=> (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Int]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Int)) (!
      (=> (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Int]_prog.subset_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Int)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Int]_prog.equality_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=> (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Int]_prog.native_equality|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Int)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Int]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Int]_prog.cardinality_difference|)))
(assert (forall ((s Set<$Snap>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Snap]_prog.card_non_negative|)))
(assert (forall ((e $Snap)) (!
  (not (Set_in e (as Set_empty  Set<$Snap>)))
  :pattern ((Set_in e (as Set_empty  Set<$Snap>)))
  :qid |$Set[Snap]_prog.in_empty_set|)))
(assert (forall ((s Set<$Snap>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<$Snap>)))
    (=>
      (not (= (Set_card s) 0))
      (exists ((e $Snap)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Snap]_prog.empty_set_cardinality|)))
(assert (forall ((e $Snap)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Snap]_prog.in_singleton_set|)))
(assert (forall ((e1 $Snap) (e2 $Snap)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Snap]_prog.in_singleton_set_equality|)))
(assert (forall ((e $Snap)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Snap]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Snap]_prog.in_unionone_same|)))
(assert (forall ((s Set<$Snap>) (e1 $Snap) (e2 $Snap)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Snap]_prog.in_unionone_other|)))
(assert (forall ((s Set<$Snap>) (e1 $Snap) (e2 $Snap)) (!
  (=> (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Snap]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (=> (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Snap]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (=> (not (Set_in e s)) (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Snap]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Snap]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (=> (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Snap]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (=> (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Snap]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Snap]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Snap]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Snap]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Snap]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Snap]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Snap]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Snap]_prog.in_difference|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (=> (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Snap]_prog.not_in_difference|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e $Snap)) (!
      (=> (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Snap]_prog.subset_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e $Snap)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Snap]_prog.equality_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=> (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Snap]_prog.native_equality|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e $Snap)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Snap]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Snap]_prog.cardinality_difference|)))
; /field_value_functions_axioms.smt2 [first: Ref]
(assert (forall ((vs $FVF<first>) (ws $FVF<first>)) (!
    (=>
      (and
        (Set_equal ($FVF.domain_first vs) ($FVF.domain_first ws))
        (forall ((x $Ref)) (!
          (=>
            (Set_in x ($FVF.domain_first vs))
            (= ($FVF.lookup_first vs x) ($FVF.lookup_first ws x)))
          :pattern (($FVF.lookup_first vs x) ($FVF.lookup_first ws x))
          :qid |qp.$FVF<first>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<first>To$Snap vs)
              ($SortWrappers.$FVF<first>To$Snap ws)
              )
    :qid |qp.$FVF<first>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_first pm r))
    :pattern (($FVF.perm_first pm r)))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_first f r) true)
    :pattern (($FVF.loc_first f r)))))
; /field_value_functions_axioms.smt2 [second: Ref]
(assert (forall ((vs $FVF<second>) (ws $FVF<second>)) (!
    (=>
      (and
        (Set_equal ($FVF.domain_second vs) ($FVF.domain_second ws))
        (forall ((x $Ref)) (!
          (=>
            (Set_in x ($FVF.domain_second vs))
            (= ($FVF.lookup_second vs x) ($FVF.lookup_second ws x)))
          :pattern (($FVF.lookup_second vs x) ($FVF.lookup_second ws x))
          :qid |qp.$FVF<second>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<second>To$Snap vs)
              ($SortWrappers.$FVF<second>To$Snap ws)
              )
    :qid |qp.$FVF<second>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_second pm r))
    :pattern (($FVF.perm_second pm r)))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_second f r) true)
    :pattern (($FVF.loc_second f r)))))
; /field_value_functions_axioms.smt2 [val: Int]
(assert (forall ((vs $FVF<val>) (ws $FVF<val>)) (!
    (=>
      (and
        (Set_equal ($FVF.domain_val vs) ($FVF.domain_val ws))
        (forall ((x $Ref)) (!
          (=>
            (Set_in x ($FVF.domain_val vs))
            (= ($FVF.lookup_val vs x) ($FVF.lookup_val ws x)))
          :pattern (($FVF.lookup_val vs x) ($FVF.lookup_val ws x))
          :qid |qp.$FVF<val>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<val>To$Snap vs)
              ($SortWrappers.$FVF<val>To$Snap ws)
              )
    :qid |qp.$FVF<val>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_val pm r))
    :pattern (($FVF.perm_val pm r)))))
(assert (forall ((r $Ref) (f Int)) (!
    (= ($FVF.loc_val f r) true)
    :pattern (($FVF.loc_val f r)))))
; End preamble
; ------------------------------------------------------------
; State saturation: after preamble
(set-option :timeout 100)
(check-sat)
; unknown
; ------------------------------------------------------------
; Begin function- and predicate-related preamble
; Declaring symbols related to program functions (from verification)
(assert (forall ((s@$ $Snap) (i@0@00 Int)) (!
  (= (address%limited s@$ i@0@00) (address s@$ i@0@00))
  :pattern ((address s@$ i@0@00))
  :qid |quant-u-41|)))
(assert (forall ((s@$ $Snap) (i@0@00 Int)) (!
  (address%stateless i@0@00)
  :pattern ((address%limited s@$ i@0@00))
  :qid |quant-u-42|)))
; End function- and predicate-related preamble
; ------------------------------------------------------------
; ---------- inc ----------
(declare-const nodes@0@04 Set<$Ref>)
(declare-const x@1@04 $Ref)
(declare-const nodes@2@04 Set<$Ref>)
(declare-const x@3@04 $Ref)
(set-option :timeout 0)
(push) ; 1
(declare-const $t@4@04 $Snap)
(assert (= $t@4@04 ($Snap.combine ($Snap.first $t@4@04) ($Snap.second $t@4@04))))
(declare-const n@5@04 $Ref)
(push) ; 2
; [eval] (n in nodes)
(assert (Set_in n@5@04 nodes@2@04))
(declare-const sm@6@04 $FVF<first>)
; Definitional axioms for snapshot map values
(pop) ; 2
(declare-fun inv@7@04 ($Ref) $Ref)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
; Check receiver injectivity
(push) ; 2
(assert (not (forall ((n1@5@04 $Ref) (n2@5@04 $Ref)) (!
  (=>
    (and
      (Set_in n1@5@04 nodes@2@04)
      (Set_in n2@5@04 nodes@2@04)
      (= n1@5@04 n2@5@04))
    (= n1@5@04 n2@5@04))
  
  :qid |first-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; Definitional axioms for inverse functions
(assert (forall ((n@5@04 $Ref)) (!
  (=> (Set_in n@5@04 nodes@2@04) (= (inv@7@04 n@5@04) n@5@04))
  :pattern (($FVF.loc_first ($FVF.lookup_first ($SortWrappers.$SnapTo$FVF<first> ($Snap.first $t@4@04)) n@5@04) n@5@04))
  :qid |quant-u-44|)))
(assert (forall ((r $Ref)) (!
  (=> (Set_in (inv@7@04 r) nodes@2@04) (= (inv@7@04 r) r))
  :pattern ((inv@7@04 r))
  :qid |first-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((n@5@04 $Ref)) (!
  (=> (Set_in n@5@04 nodes@2@04) (not (= n@5@04 $Ref.null)))
  :pattern (($FVF.loc_first ($FVF.lookup_first ($SortWrappers.$SnapTo$FVF<first> ($Snap.first $t@4@04)) n@5@04) n@5@04))
  :qid |first-permImpliesNonNull|)))
(declare-const sm@8@04 $FVF<first>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (=>
    (Set_in (inv@7@04 r) nodes@2@04)
    (=
      ($FVF.lookup_first (as sm@8@04  $FVF<first>) r)
      ($FVF.lookup_first ($SortWrappers.$SnapTo$FVF<first> ($Snap.first $t@4@04)) r)))
  :pattern (($FVF.lookup_first (as sm@8@04  $FVF<first>) r))
  :pattern (($FVF.lookup_first ($SortWrappers.$SnapTo$FVF<first> ($Snap.first $t@4@04)) r))
  :qid |qp.fvfValDef1|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_first ($FVF.lookup_first ($SortWrappers.$SnapTo$FVF<first> ($Snap.first $t@4@04)) r) r)
  :pattern (($FVF.lookup_first (as sm@8@04  $FVF<first>) r))
  :qid |qp.fvfResTrgDef2|)))
(assert (forall ((r $Ref)) (!
  (=>
    (Set_in (inv@7@04 r) nodes@2@04)
    ($FVF.loc_first ($FVF.lookup_first (as sm@8@04  $FVF<first>) r) r))
  :pattern ((inv@7@04 r))
  :qid |quant-u-45|)))
(assert (=
  ($Snap.second $t@4@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@4@04))
    ($Snap.second ($Snap.second $t@4@04)))))
(assert (= ($Snap.first ($Snap.second $t@4@04)) $Snap.unit))
; [eval] (forall n: Ref :: { n.first } (n in nodes) ==> n.first != null ==> (n.first in nodes))
(declare-const n@9@04 $Ref)
(push) ; 2
; [eval] (n in nodes) ==> n.first != null ==> (n.first in nodes)
; [eval] (n in nodes)
(push) ; 3
; [then-branch: 0 | n@9@04 in nodes@2@04 | live]
; [else-branch: 0 | !(n@9@04 in nodes@2@04) | live]
(push) ; 4
; [then-branch: 0 | n@9@04 in nodes@2@04]
(assert (Set_in n@9@04 nodes@2@04))
; [eval] n.first != null ==> (n.first in nodes)
; [eval] n.first != null
(assert ($FVF.loc_first ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) n@9@04))
(push) ; 5
(assert (not (Set_in (inv@7@04 n@9@04) nodes@2@04)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(push) ; 5
; [then-branch: 1 | Lookup(first,sm@8@04,n@9@04) != Null | live]
; [else-branch: 1 | Lookup(first,sm@8@04,n@9@04) == Null | live]
(push) ; 6
; [then-branch: 1 | Lookup(first,sm@8@04,n@9@04) != Null]
(assert (not (= ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) $Ref.null)))
; [eval] (n.first in nodes)
(push) ; 7
(assert (not (Set_in (inv@7@04 n@9@04) nodes@2@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(pop) ; 6
(push) ; 6
; [else-branch: 1 | Lookup(first,sm@8@04,n@9@04) == Null]
(assert (= ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) $Ref.null))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (or
  (= ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) $Ref.null)
  (not (= ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) $Ref.null))))
(pop) ; 4
(push) ; 4
; [else-branch: 0 | !(n@9@04 in nodes@2@04)]
(assert (not (Set_in n@9@04 nodes@2@04)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=>
  (Set_in n@9@04 nodes@2@04)
  (and
    (Set_in n@9@04 nodes@2@04)
    ($FVF.loc_first ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) n@9@04)
    (or
      (= ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) $Ref.null)
      (not (= ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) $Ref.null))))))
; Joined path conditions
(assert (or (not (Set_in n@9@04 nodes@2@04)) (Set_in n@9@04 nodes@2@04)))
; Definitional axioms for snapshot map values
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((n@9@04 $Ref)) (!
  (and
    (=>
      (Set_in n@9@04 nodes@2@04)
      (and
        (Set_in n@9@04 nodes@2@04)
        ($FVF.loc_first ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) n@9@04)
        (or
          (= ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) $Ref.null)
          (not
            (= ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) $Ref.null)))))
    (or (not (Set_in n@9@04 nodes@2@04)) (Set_in n@9@04 nodes@2@04)))
  :pattern (($FVF.loc_first ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) n@9@04))
  :qid |prog.l5-aux|)))
(assert (forall ((n@9@04 $Ref)) (!
  (=>
    (and
      (Set_in n@9@04 nodes@2@04)
      (not (= ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) $Ref.null)))
    (Set_in ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) nodes@2@04))
  :pattern (($FVF.loc_first ($FVF.lookup_first (as sm@8@04  $FVF<first>) n@9@04) n@9@04))
  :qid |prog.l5|)))
(assert (=
  ($Snap.second ($Snap.second $t@4@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@4@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@4@04))))))
(declare-const n@10@04 $Ref)
(push) ; 2
; [eval] (n in nodes)
(assert (Set_in n@10@04 nodes@2@04))
(declare-const sm@11@04 $FVF<second>)
; Definitional axioms for snapshot map values
(pop) ; 2
(declare-fun inv@12@04 ($Ref) $Ref)
; Nested auxiliary terms: globals
; Nested auxiliary terms: non-globals
; Check receiver injectivity
(push) ; 2
(assert (not (forall ((n1@10@04 $Ref) (n2@10@04 $Ref)) (!
  (=>
    (and
      (Set_in n1@10@04 nodes@2@04)
      (Set_in n2@10@04 nodes@2@04)
      (= n1@10@04 n2@10@04))
    (= n1@10@04 n2@10@04))
  
  :qid |second-rcvrInj|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; Definitional axioms for inverse functions
(assert (forall ((n@10@04 $Ref)) (!
  (=> (Set_in n@10@04 nodes@2@04) (= (inv@12@04 n@10@04) n@10@04))
  :pattern (($FVF.loc_second ($FVF.lookup_second ($SortWrappers.$SnapTo$FVF<second> ($Snap.first ($Snap.second ($Snap.second $t@4@04)))) n@10@04) n@10@04))
  :qid |quant-u-47|)))
(assert (forall ((r $Ref)) (!
  (=> (Set_in (inv@12@04 r) nodes@2@04) (= (inv@12@04 r) r))
  :pattern ((inv@12@04 r))
  :qid |second-fctOfInv|)))
; Permissions are non-negative
; Field permissions are at most one
; Permission implies non-null receiver
(assert (forall ((n@10@04 $Ref)) (!
  (=> (Set_in n@10@04 nodes@2@04) (not (= n@10@04 $Ref.null)))
  :pattern (($FVF.loc_second ($FVF.lookup_second ($SortWrappers.$SnapTo$FVF<second> ($Snap.first ($Snap.second ($Snap.second $t@4@04)))) n@10@04) n@10@04))
  :qid |second-permImpliesNonNull|)))
(declare-const sm@13@04 $FVF<second>)
; Definitional axioms for snapshot map values
(assert (forall ((r $Ref)) (!
  (=>
    (Set_in (inv@12@04 r) nodes@2@04)
    (=
      ($FVF.lookup_second (as sm@13@04  $FVF<second>) r)
      ($FVF.lookup_second ($SortWrappers.$SnapTo$FVF<second> ($Snap.first ($Snap.second ($Snap.second $t@4@04)))) r)))
  :pattern (($FVF.lookup_second (as sm@13@04  $FVF<second>) r))
  :pattern (($FVF.lookup_second ($SortWrappers.$SnapTo$FVF<second> ($Snap.first ($Snap.second ($Snap.second $t@4@04)))) r))
  :qid |qp.fvfValDef4|)))
(assert (forall ((r $Ref)) (!
  ($FVF.loc_second ($FVF.lookup_second ($SortWrappers.$SnapTo$FVF<second> ($Snap.first ($Snap.second ($Snap.second $t@4@04)))) r) r)
  :pattern (($FVF.lookup_second (as sm@13@04  $FVF<second>) r))
  :qid |qp.fvfResTrgDef5|)))
(assert (forall ((r $Ref)) (!
  (=>
    (Set_in (inv@12@04 r) nodes@2@04)
    ($FVF.loc_second ($FVF.lookup_second (as sm@13@04  $FVF<second>) r) r))
  :pattern ((inv@12@04 r))
  :qid |quant-u-48|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@4@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@04)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@04)))) $Snap.unit))
; [eval] (forall n: Ref :: { n.second } (n in nodes) ==> n.second != null ==> (n.second in nodes))
(declare-const n@14@04 $Ref)
(push) ; 2
; [eval] (n in nodes) ==> n.second != null ==> (n.second in nodes)
; [eval] (n in nodes)
(push) ; 3
; [then-branch: 2 | n@14@04 in nodes@2@04 | live]
; [else-branch: 2 | !(n@14@04 in nodes@2@04) | live]
(push) ; 4
; [then-branch: 2 | n@14@04 in nodes@2@04]
(assert (Set_in n@14@04 nodes@2@04))
; [eval] n.second != null ==> (n.second in nodes)
; [eval] n.second != null
(assert ($FVF.loc_second ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) n@14@04))
(push) ; 5
(assert (not (Set_in (inv@12@04 n@14@04) nodes@2@04)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(push) ; 5
; [then-branch: 3 | Lookup(second,sm@13@04,n@14@04) != Null | live]
; [else-branch: 3 | Lookup(second,sm@13@04,n@14@04) == Null | live]
(push) ; 6
; [then-branch: 3 | Lookup(second,sm@13@04,n@14@04) != Null]
(assert (not (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) $Ref.null)))
; [eval] (n.second in nodes)
(push) ; 7
(assert (not (Set_in (inv@12@04 n@14@04) nodes@2@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(pop) ; 6
(push) ; 6
; [else-branch: 3 | Lookup(second,sm@13@04,n@14@04) == Null]
(assert (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) $Ref.null))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(assert (or
  (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) $Ref.null)
  (not (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) $Ref.null))))
(pop) ; 4
(push) ; 4
; [else-branch: 2 | !(n@14@04 in nodes@2@04)]
(assert (not (Set_in n@14@04 nodes@2@04)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (=>
  (Set_in n@14@04 nodes@2@04)
  (and
    (Set_in n@14@04 nodes@2@04)
    ($FVF.loc_second ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) n@14@04)
    (or
      (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) $Ref.null)
      (not
        (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) $Ref.null))))))
; Joined path conditions
(assert (or (not (Set_in n@14@04 nodes@2@04)) (Set_in n@14@04 nodes@2@04)))
; Definitional axioms for snapshot map values
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((n@14@04 $Ref)) (!
  (and
    (=>
      (Set_in n@14@04 nodes@2@04)
      (and
        (Set_in n@14@04 nodes@2@04)
        ($FVF.loc_second ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) n@14@04)
        (or
          (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) $Ref.null)
          (not
            (=
              ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04)
              $Ref.null)))))
    (or (not (Set_in n@14@04 nodes@2@04)) (Set_in n@14@04 nodes@2@04)))
  :pattern (($FVF.loc_second ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) n@14@04))
  :qid |prog.l8-aux|)))
(assert (forall ((n@14@04 $Ref)) (!
  (=>
    (and
      (Set_in n@14@04 nodes@2@04)
      (not
        (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) $Ref.null)))
    (Set_in ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) nodes@2@04))
  :pattern (($FVF.loc_second ($FVF.lookup_second (as sm@13@04  $FVF<second>) n@14@04) n@14@04))
  :qid |prog.l8|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@04))))
  $Snap.unit))
; [eval] (x in nodes)
(assert (Set_in x@3@04 nodes@2@04))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(set-option :timeout 0)
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; var y: Ref
(declare-const y@15@04 $Ref)
; [eval] x.second != null
(assert ($FVF.loc_second ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04) x@3@04))
(push) ; 3
(assert (not (Set_in (inv@12@04 x@3@04) nodes@2@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(push) ; 3
(set-option :timeout 10)
(assert (not (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04) $Ref.null)))
(check-sat)
; unknown
(get-model)
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(set-option :timeout 0)
(push) ; 3
(set-option :timeout 10)
(assert (not (not (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04) $Ref.null))))
(check-sat)
; unknown
(get-model)
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 4 | Lookup(second,sm@13@04,x@3@04) != Null | live]
; [else-branch: 4 | Lookup(second,sm@13@04,x@3@04) == Null | live]
(set-option :timeout 0)
(push) ; 3
; [then-branch: 4 | Lookup(second,sm@13@04,x@3@04) != Null]
(assert (not (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04) $Ref.null)))
; [exec]
; y := x.second.first
(push) ; 4
(assert (not (Set_in (inv@12@04 x@3@04) nodes@2@04)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(assert ($FVF.loc_first ($FVF.lookup_first (as sm@8@04  $FVF<first>) ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04)) ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04)))
(push) ; 4
(assert (not (Set_in (inv@7@04 ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04)) nodes@2@04)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(declare-const y@16@04 $Ref)
(assert (=
  y@16@04
  ($FVF.lookup_first (as sm@8@04  $FVF<first>) ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04))))
(pop) ; 3
(push) ; 3
; [else-branch: 4 | Lookup(second,sm@13@04,x@3@04) == Null]
(assert (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04) $Ref.null))
(pop) ; 3
; [eval] !(x.second != null)
; [eval] x.second != null
(push) ; 3
(assert (not (Set_in (inv@12@04 x@3@04) nodes@2@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(push) ; 3
(set-option :timeout 10)
(assert (not (not (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04) $Ref.null))))
(check-sat)
; unknown
(get-model)
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(set-option :timeout 0)
(push) ; 3
(set-option :timeout 10)
(assert (not (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04) $Ref.null)))
(check-sat)
; unknown
(get-model)
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 5 | Lookup(second,sm@13@04,x@3@04) == Null | live]
; [else-branch: 5 | Lookup(second,sm@13@04,x@3@04) != Null | live]
(set-option :timeout 0)
(push) ; 3
; [then-branch: 5 | Lookup(second,sm@13@04,x@3@04) == Null]
(assert (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04) $Ref.null))
(pop) ; 3
(push) ; 3
; [else-branch: 5 | Lookup(second,sm@13@04,x@3@04) != Null]
(assert (not (= ($FVF.lookup_second (as sm@13@04  $FVF<second>) x@3@04) $Ref.null)))
(pop) ; 3
(pop) ; 2
(pop) ; 1
