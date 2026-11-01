; ModuleID = '/home/amd/Workspace/HLS_IP/yolo_postprocess/build/yolo_postprocess/solution_200mhz/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"struct.ap_uint<128>" = type { %"struct.ap_int_base<128, false>" }
%"struct.ap_int_base<128, false>" = type { %"struct.ssdm_int<128, false>" }
%"struct.ssdm_int<128, false>" = type { i128 }
%"struct.ap_uint<256>" = type { %"struct.ap_int_base<256, false>" }
%"struct.ap_int_base<256, false>" = type { %"struct.ssdm_int<256, false>" }
%"struct.ssdm_int<256, false>" = type { i256 }

; Function Attrs: noinline
define i32 @apatb_yolo_postprocess_ir(%"struct.ap_uint<128>"* noalias nocapture nonnull readonly %input, i32* noalias nocapture nonnull readonly %tables, %"struct.ap_uint<256>"* noalias nocapture nonnull %output, i32 %input_words, i32 %table_words, i32 %output_capacity, i32 %confidence_q30, i32 %nms_q16, i32 %enable_nms, i32* noalias nocapture nonnull dereferenceable(4) %candidate_count, i32* noalias nocapture nonnull dereferenceable(4) %detection_count) local_unnamed_addr #0 {
entry:
  %malloccall = call i8* @malloc(i64 905008)
  %input_copy = bitcast i8* %malloccall to [56563 x i128]*
  %malloccall1 = tail call i8* @malloc(i64 21504)
  %tables_copy = bitcast i8* %malloccall1 to [5376 x i32]*
  %malloccall2 = call i8* @malloc(i64 8192)
  %output_copy = bitcast i8* %malloccall2 to [256 x i256]*
  %candidate_count_copy = alloca i32, align 512
  %detection_count_copy = alloca i32, align 512
  %0 = bitcast %"struct.ap_uint<128>"* %input to [56563 x %"struct.ap_uint<128>"]*
  %1 = bitcast i32* %tables to [5376 x i32]*
  %2 = bitcast %"struct.ap_uint<256>"* %output to [256 x %"struct.ap_uint<256>"]*
  call fastcc void @copy_in([56563 x %"struct.ap_uint<128>"]* nonnull %0, [56563 x i128]* %input_copy, [5376 x i32]* nonnull %1, [5376 x i32]* %tables_copy, [256 x %"struct.ap_uint<256>"]* nonnull %2, [256 x i256]* %output_copy, i32* nonnull %candidate_count, i32* nonnull align 512 %candidate_count_copy, i32* nonnull %detection_count, i32* nonnull align 512 %detection_count_copy)
  %3 = getelementptr [56563 x i128], [56563 x i128]* %input_copy, i32 0, i32 0
  %4 = getelementptr inbounds [5376 x i32], [5376 x i32]* %tables_copy, i32 0, i32 0
  %5 = getelementptr [256 x i256], [256 x i256]* %output_copy, i32 0, i32 0
  %6 = call i32 @apatb_yolo_postprocess_hw(i128* %3, i32* %4, i256* %5, i32 %input_words, i32 %table_words, i32 %output_capacity, i32 %confidence_q30, i32 %nms_q16, i32 %enable_nms, i32* %candidate_count_copy, i32* %detection_count_copy)
  call void @copy_back([56563 x %"struct.ap_uint<128>"]* %0, [56563 x i128]* %input_copy, [5376 x i32]* %1, [5376 x i32]* %tables_copy, [256 x %"struct.ap_uint<256>"]* %2, [256 x i256]* %output_copy, i32* %candidate_count, i32* %candidate_count_copy, i32* %detection_count, i32* %detection_count_copy)
  call void @free(i8* %malloccall)
  tail call void @free(i8* %malloccall1)
  call void @free(i8* %malloccall2)
  ret i32 %6
}

declare noalias i8* @malloc(i64) local_unnamed_addr

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @copy_in([56563 x %"struct.ap_uint<128>"]* noalias readonly, [56563 x i128]* noalias, [5376 x i32]* noalias readonly, [5376 x i32]* noalias, [256 x %"struct.ap_uint<256>"]* noalias readonly, [256 x i256]* noalias, i32* noalias readonly, i32* noalias align 512, i32* noalias readonly, i32* noalias align 512) unnamed_addr #1 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a56563struct.ap_uint<128>.43"([56563 x i128]* %1, [56563 x %"struct.ap_uint<128>"]* %0)
  call fastcc void @onebyonecpy_hls.p0a5376i32([5376 x i32]* %3, [5376 x i32]* %2)
  call fastcc void @"onebyonecpy_hls.p0a256struct.ap_uint<256>"([256 x i256]* %5, [256 x %"struct.ap_uint<256>"]* %4)
  call fastcc void @onebyonecpy_hls.p0i32(i32* align 512 %7, i32* %6)
  call fastcc void @onebyonecpy_hls.p0i32(i32* align 512 %9, i32* %8)
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a56563struct.ap_uint<128>"([56563 x %"struct.ap_uint<128>"]* noalias, [56563 x i128]* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq [56563 x %"struct.ap_uint<128>"]* %0, null
  %3 = icmp eq [56563 x i128]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %5 = getelementptr [56563 x i128], [56563 x i128]* %1, i64 0, i64 %for.loop.idx7
  %dst.addr.0.0.06 = getelementptr [56563 x %"struct.ap_uint<128>"], [56563 x %"struct.ap_uint<128>"]* %0, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %6 = load i128, i128* %5, align 16
  store i128 %6, i128* %dst.addr.0.0.06, align 16
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 56563
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @onebyonecpy_hls.p0a5376i32([5376 x i32]* noalias, [5376 x i32]* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq [5376 x i32]* %0, null
  %3 = icmp eq [5376 x i32]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx1 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %dst.addr = getelementptr [5376 x i32], [5376 x i32]* %0, i64 0, i64 %for.loop.idx1
  %src.addr = getelementptr [5376 x i32], [5376 x i32]* %1, i64 0, i64 %for.loop.idx1
  %5 = load i32, i32* %src.addr, align 4
  store i32 %5, i32* %dst.addr, align 4
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx1, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 5376
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a256struct.ap_uint<256>"([256 x i256]* noalias, [256 x %"struct.ap_uint<256>"]* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq [256 x i256]* %0, null
  %3 = icmp eq [256 x %"struct.ap_uint<256>"]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [256 x %"struct.ap_uint<256>"], [256 x %"struct.ap_uint<256>"]* %1, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %5 = getelementptr [256 x i256], [256 x i256]* %0, i64 0, i64 %for.loop.idx7
  %6 = load i256, i256* %src.addr.0.0.05, align 32
  store i256 %6, i256* %5, align 32
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 256
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @onebyonecpy_hls.p0i32(i32* noalias align 512, i32* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq i32* %0, null
  %3 = icmp eq i32* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  %5 = load i32, i32* %1, align 4
  store i32 %5, i32* %0, align 512
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @copy_out([56563 x %"struct.ap_uint<128>"]* noalias, [56563 x i128]* noalias readonly, [5376 x i32]* noalias, [5376 x i32]* noalias readonly, [256 x %"struct.ap_uint<256>"]* noalias, [256 x i256]* noalias readonly, i32* noalias, i32* noalias readonly align 512, i32* noalias, i32* noalias readonly align 512) unnamed_addr #3 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a56563struct.ap_uint<128>"([56563 x %"struct.ap_uint<128>"]* %0, [56563 x i128]* %1)
  call fastcc void @onebyonecpy_hls.p0a5376i32([5376 x i32]* %2, [5376 x i32]* %3)
  call fastcc void @"onebyonecpy_hls.p0a256struct.ap_uint<256>.37"([256 x %"struct.ap_uint<256>"]* %4, [256 x i256]* %5)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %6, i32* align 512 %7)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %8, i32* align 512 %9)
  ret void
}

declare void @free(i8*) local_unnamed_addr

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a256struct.ap_uint<256>.37"([256 x %"struct.ap_uint<256>"]* noalias, [256 x i256]* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq [256 x %"struct.ap_uint<256>"]* %0, null
  %3 = icmp eq [256 x i256]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %5 = getelementptr [256 x i256], [256 x i256]* %1, i64 0, i64 %for.loop.idx7
  %dst.addr.0.0.06 = getelementptr [256 x %"struct.ap_uint<256>"], [256 x %"struct.ap_uint<256>"]* %0, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %6 = load i256, i256* %5, align 32
  store i256 %6, i256* %dst.addr.0.0.06, align 32
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 256
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a56563struct.ap_uint<128>.43"([56563 x i128]* noalias, [56563 x %"struct.ap_uint<128>"]* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq [56563 x i128]* %0, null
  %3 = icmp eq [56563 x %"struct.ap_uint<128>"]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [56563 x %"struct.ap_uint<128>"], [56563 x %"struct.ap_uint<128>"]* %1, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %5 = getelementptr [56563 x i128], [56563 x i128]* %0, i64 0, i64 %for.loop.idx7
  %6 = load i128, i128* %src.addr.0.0.05, align 16
  store i128 %6, i128* %5, align 16
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 56563
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

declare i32 @apatb_yolo_postprocess_hw(i128*, i32*, i256*, i32, i32, i32, i32, i32, i32, i32*, i32*)

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @copy_back([56563 x %"struct.ap_uint<128>"]* noalias, [56563 x i128]* noalias readonly, [5376 x i32]* noalias, [5376 x i32]* noalias readonly, [256 x %"struct.ap_uint<256>"]* noalias, [256 x i256]* noalias readonly, i32* noalias, i32* noalias readonly align 512, i32* noalias, i32* noalias readonly align 512) unnamed_addr #3 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a256struct.ap_uint<256>.37"([256 x %"struct.ap_uint<256>"]* %4, [256 x i256]* %5)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %6, i32* align 512 %7)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %8, i32* align 512 %9)
  ret void
}

define i32 @yolo_postprocess_hw_stub_wrapper(i128*, i32*, i256*, i32, i32, i32, i32, i32, i32, i32*, i32*) #4 {
entry:
  %malloccall = tail call i8* @malloc(i64 905008)
  %11 = bitcast i8* %malloccall to [56563 x %"struct.ap_uint<128>"]*
  %malloccall1 = tail call i8* @malloc(i64 8192)
  %12 = bitcast i8* %malloccall1 to [256 x %"struct.ap_uint<256>"]*
  %13 = bitcast i128* %0 to [56563 x i128]*
  %14 = bitcast i32* %1 to [5376 x i32]*
  %15 = bitcast i256* %2 to [256 x i256]*
  call void @copy_out([56563 x %"struct.ap_uint<128>"]* %11, [56563 x i128]* %13, [5376 x i32]* null, [5376 x i32]* %14, [256 x %"struct.ap_uint<256>"]* %12, [256 x i256]* %15, i32* null, i32* %9, i32* null, i32* %10)
  %16 = bitcast [56563 x %"struct.ap_uint<128>"]* %11 to %"struct.ap_uint<128>"*
  %17 = bitcast [5376 x i32]* %14 to i32*
  %18 = bitcast [256 x %"struct.ap_uint<256>"]* %12 to %"struct.ap_uint<256>"*
  %19 = call i32 @yolo_postprocess_hw_stub(%"struct.ap_uint<128>"* %16, i32* %17, %"struct.ap_uint<256>"* %18, i32 %3, i32 %4, i32 %5, i32 %6, i32 %7, i32 %8, i32* %9, i32* %10)
  call void @copy_in([56563 x %"struct.ap_uint<128>"]* %11, [56563 x i128]* %13, [5376 x i32]* null, [5376 x i32]* %14, [256 x %"struct.ap_uint<256>"]* %12, [256 x i256]* %15, i32* null, i32* %9, i32* null, i32* %10)
  ret i32 %19
}

declare i32 @yolo_postprocess_hw_stub(%"struct.ap_uint<128>"*, i32*, %"struct.ap_uint<256>"*, i32, i32, i32, i32, i32, i32, i32*, i32*)

attributes #0 = { noinline "fpga.wrapper.func"="wrapper" }
attributes #1 = { argmemonly noinline norecurse "fpga.wrapper.func"="copyin" }
attributes #2 = { argmemonly noinline norecurse "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #3 = { argmemonly noinline norecurse "fpga.wrapper.func"="copyout" }
attributes #4 = { "fpga.wrapper.func"="stub" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
