; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m,+d,+zfh,+experimental-zvfh,+v -target-abi=ilp32d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s --check-prefixes=RV32
; RUN: llc -mtriple=riscv64 -mattr=+m,+d,+zfh,+experimental-zvfh,+v -target-abi=lp64d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s --check-prefixes=RV64

%struct = type { i64, i64, ptr, i32, i32, i32, [4 x i32] }

define void @complex_gep(ptr %p, <vscale x 2 x i64> %vec.ind, <vscale x 2 x i1> %m) {
; RV32-LABEL: complex_gep:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; RV32-NEXT:    vnsrl.wi v10, v8, 0
; RV32-NEXT:    li a1, 48
; RV32-NEXT:    vmul.vx v8, v10, a1
; RV32-NEXT:    addi a0, a0, 28
; RV32-NEXT:    vmv.v.i v9, 0
; RV32-NEXT:    vsoxei32.v v9, (a0), v8, v0.t
; RV32-NEXT:    ret
;
; RV64-LABEL: complex_gep:
; RV64:       # %bb.0:
; RV64-NEXT:    li a1, 56
; RV64-NEXT:    vsetvli a2, zero, e64, m2, ta, mu
; RV64-NEXT:    vmul.vx v8, v8, a1
; RV64-NEXT:    addi a0, a0, 32
; RV64-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; RV64-NEXT:    vmv.v.i v10, 0
; RV64-NEXT:    vsoxei64.v v10, (a0), v8, v0.t
; RV64-NEXT:    ret
  %gep = getelementptr inbounds %struct, ptr %p, <vscale x 2 x i64> %vec.ind, i32 5
  call void @llvm.masked.scatter.nxv2i32.nxv2p0(<vscale x 2 x i32> zeroinitializer, <vscale x 2 x ptr> %gep, i32 8, <vscale x 2 x i1> %m)
  ret void
}

declare void @llvm.masked.scatter.nxv2i32.nxv2p0(<vscale x 2 x i32>, <vscale x 2 x ptr>, i32, <vscale x 2 x i1>)
