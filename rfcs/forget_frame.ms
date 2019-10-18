- Feature Name: forgetting_rust_frames
- Start Date: 2019-10-18
- RFC PR: [rust-lang/rfcs#0000](https://github.com/rust-lang/rfcs/pull/0000)
- Rust Issue: [rust-lang/rust#0000](https://github.com/rust-lang/rust/issues/0000)

# Summary
[summary]: #summary

This RFC guarantees that the behavior of deallocating a Rust stack frame containing automatic variables that do not have drop glue is _safe_.

# Motivation
[motivation]: #motivation

(TODO: this paragraph is @kyren expertise)
The [rlua] Rust library is called from C and it calls C code.
Here, the C code [rlua] calls does a [longjmp] back to the C code that calls [rlua].

On some platforms, `longjmp` dealocates the Rust frames without invoking destructors.

Currently, we make no guarantees about the behavior of such Rust programs.
This RFC changes that.

# Guide-level explanation
[guide-level-explanation]: #guide-level-explanation

This RFC guarantees that the behavior of deallocating a Rust frame is _well-defined_ if the Rust frame does not contain drop glue.
The semantics of this operation are then equivalent to calling `mem::forget` on
all automatic-variables contained in this frame.

This removes some undefined behavior from the language by making it _well-defined_.

# Reference-level explanation
[reference-level-explanation]: #reference-level-explanation

Same as the guide-level explanation.

# Drawbacks
[drawbacks]: #drawbacks

None known yet.

# Rationale and alternatives
[rationale-and-alternatives]: #rationale-and-alternatives

We could decide not do this and that would mean that the behavior of `rlua` and similar crates remains undefined.

# Prior art
[prior-art]: #prior-art

C++ also contains this guarantee.

# Unresolved questions
[unresolved-questions]: #unresolved-questions

None yet.

# Future possibilities
[future-possibilities]: #future-possibilities

A future RFC could further define the behavior for the cases in which the Rust
frames do contain types with destructors, as long as these types do not require
their destructors to run before their memory is deallocated for _safety_ (e.g.
like `Pin`). 

Other future RFCs could allow calling [setjmp] from Rust.

