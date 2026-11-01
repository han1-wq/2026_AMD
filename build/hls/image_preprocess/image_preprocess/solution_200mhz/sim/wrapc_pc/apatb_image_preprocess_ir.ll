; ModuleID = '/home/amd/Workspace/HLS_IP/image_preprocess/build/image_preprocess/solution_200mhz/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"struct.ap_uint<128>" = type { %"struct.ap_int_base<128, false>" }
%"struct.ap_int_base<128, false>" = type { %"struct.ssdm_int<128, false>" }
%"struct.ssdm_int<128, false>" = type { i128 }

; Function Attrs: noinline
define i32 @apatb_image_preprocess_ir(%"struct.ap_uint<128>"* noalias nocapture nonnull readonly %src, %"struct.ap_uint<128>"* noalias nocapture nonnull %tensor, %"struct.ap_uint<128>"* noalias nocapture nonnull %preview, %"struct.ap_uint<128>"* noalias nocapture nonnull readonly %luts, i32 %width, i32 %height, i32 %src_stride, i32 %src_capacity, i32 %tensor_capacity, i32 %preview_stride, i32 %preview_capacity, i32 %resized_w, i32 %resized_h, i32 %pad_x, i32 %pad_y, i32 %output_mode, i32 %flags, i32 %eq_mode, i32 %saturation_q12, i32 %frame_id, i32 %config_id, i32* noalias nocapture nonnull dereferenceable(4) %completed_frame_id, i32* noalias nocapture nonnull dereferenceable(4) %completed_config_id, i32* noalias nocapture nonnull dereferenceable(4) %tensor_bytes, i32* noalias nocapture nonnull dereferenceable(4) %preview_bytes, i32* noalias nocapture nonnull dereferenceable(4) %abi_version) local_unnamed_addr #0 {
entry:
  %malloccall = call i8* @malloc(i64 6220800)
  %src_copy = bitcast i8* %malloccall to [388800 x i128]*
  %malloccall1 = call i8* @malloc(i64 519168)
  %tensor_copy = bitcast i8* %malloccall1 to [32448 x i128]*
  %malloccall2 = call i8* @malloc(i64 6220800)
  %preview_copy = bitcast i8* %malloccall2 to [388800 x i128]*
  %luts_copy = alloca [32 x i128], align 512
  %completed_frame_id_copy = alloca i32, align 512
  %completed_config_id_copy = alloca i32, align 512
  %tensor_bytes_copy = alloca i32, align 512
  %preview_bytes_copy = alloca i32, align 512
  %abi_version_copy = alloca i32, align 512
  %0 = bitcast %"struct.ap_uint<128>"* %src to [388800 x %"struct.ap_uint<128>"]*
  %1 = bitcast %"struct.ap_uint<128>"* %tensor to [32448 x %"struct.ap_uint<128>"]*
  %2 = bitcast %"struct.ap_uint<128>"* %preview to [388800 x %"struct.ap_uint<128>"]*
  %3 = bitcast %"struct.ap_uint<128>"* %luts to [32 x %"struct.ap_uint<128>"]*
  call fastcc void @copy_in([388800 x %"struct.ap_uint<128>"]* nonnull %0, [388800 x i128]* %src_copy, [32448 x %"struct.ap_uint<128>"]* nonnull %1, [32448 x i128]* %tensor_copy, [388800 x %"struct.ap_uint<128>"]* nonnull %2, [388800 x i128]* %preview_copy, [32 x %"struct.ap_uint<128>"]* nonnull %3, [32 x i128]* nonnull align 512 %luts_copy, i32* nonnull %completed_frame_id, i32* nonnull align 512 %completed_frame_id_copy, i32* nonnull %completed_config_id, i32* nonnull align 512 %completed_config_id_copy, i32* nonnull %tensor_bytes, i32* nonnull align 512 %tensor_bytes_copy, i32* nonnull %preview_bytes, i32* nonnull align 512 %preview_bytes_copy, i32* nonnull %abi_version, i32* nonnull align 512 %abi_version_copy)
  %4 = getelementptr [388800 x i128], [388800 x i128]* %src_copy, i32 0, i32 0
  %5 = getelementptr [32448 x i128], [32448 x i128]* %tensor_copy, i32 0, i32 0
  %6 = getelementptr [388800 x i128], [388800 x i128]* %preview_copy, i32 0, i32 0
  %7 = getelementptr [32 x i128], [32 x i128]* %luts_copy, i32 0, i32 0
  %8 = call i32 @apatb_image_preprocess_hw(i128* %4, i128* %5, i128* %6, i128* %7, i32 %width, i32 %height, i32 %src_stride, i32 %src_capacity, i32 %tensor_capacity, i32 %preview_stride, i32 %preview_capacity, i32 %resized_w, i32 %resized_h, i32 %pad_x, i32 %pad_y, i32 %output_mode, i32 %flags, i32 %eq_mode, i32 %saturation_q12, i32 %frame_id, i32 %config_id, i32* %completed_frame_id_copy, i32* %completed_config_id_copy, i32* %tensor_bytes_copy, i32* %preview_bytes_copy, i32* %abi_version_copy)
  call void @copy_back([388800 x %"struct.ap_uint<128>"]* %0, [388800 x i128]* %src_copy, [32448 x %"struct.ap_uint<128>"]* %1, [32448 x i128]* %tensor_copy, [388800 x %"struct.ap_uint<128>"]* %2, [388800 x i128]* %preview_copy, [32 x %"struct.ap_uint<128>"]* %3, [32 x i128]* %luts_copy, i32* %completed_frame_id, i32* %completed_frame_id_copy, i32* %completed_config_id, i32* %completed_config_id_copy, i32* %tensor_bytes, i32* %tensor_bytes_copy, i32* %preview_bytes, i32* %preview_bytes_copy, i32* %abi_version, i32* %abi_version_copy)
  call void @free(i8* %malloccall)
  call void @free(i8* %malloccall1)
  call void @free(i8* %malloccall2)
  ret i32 %8
}

declare noalias i8* @malloc(i64) local_unnamed_addr

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @copy_in([388800 x %"struct.ap_uint<128>"]* noalias readonly, [388800 x i128]* noalias, [32448 x %"struct.ap_uint<128>"]* noalias readonly, [32448 x i128]* noalias, [388800 x %"struct.ap_uint<128>"]* noalias readonly, [388800 x i128]* noalias, [32 x %"struct.ap_uint<128>"]* noalias readonly, [32 x i128]* noalias align 512, i32* noalias readonly, i32* noalias align 512, i32* noalias readonly, i32* noalias align 512, i32* noalias readonly, i32* noalias align 512, i32* noalias readonly, i32* noalias align 512, i32* noalias readonly, i32* noalias align 512) unnamed_addr #1 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a388800struct.ap_uint<128>.139"([388800 x i128]* %1, [388800 x %"struct.ap_uint<128>"]* %0)
  call fastcc void @"onebyonecpy_hls.p0a32448struct.ap_uint<128>"([32448 x i128]* %3, [32448 x %"struct.ap_uint<128>"]* %2)
  call fastcc void @"onebyonecpy_hls.p0a388800struct.ap_uint<128>.139"([388800 x i128]* %5, [388800 x %"struct.ap_uint<128>"]* %4)
  call fastcc void @"onebyonecpy_hls.p0a32struct.ap_uint<128>"([32 x i128]* align 512 %7, [32 x %"struct.ap_uint<128>"]* %6)
  call fastcc void @onebyonecpy_hls.p0i32(i32* align 512 %9, i32* %8)
  call fastcc void @onebyonecpy_hls.p0i32(i32* align 512 %11, i32* %10)
  call fastcc void @onebyonecpy_hls.p0i32(i32* align 512 %13, i32* %12)
  call fastcc void @onebyonecpy_hls.p0i32(i32* align 512 %15, i32* %14)
  call fastcc void @onebyonecpy_hls.p0i32(i32* align 512 %17, i32* %16)
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a32448struct.ap_uint<128>"([32448 x i128]* noalias, [32448 x %"struct.ap_uint<128>"]* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq [32448 x i128]* %0, null
  %3 = icmp eq [32448 x %"struct.ap_uint<128>"]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [32448 x %"struct.ap_uint<128>"], [32448 x %"struct.ap_uint<128>"]* %1, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %5 = getelementptr [32448 x i128], [32448 x i128]* %0, i64 0, i64 %for.loop.idx7
  %6 = load i128, i128* %src.addr.0.0.05, align 16
  store i128 %6, i128* %5, align 16
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 32448
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a32struct.ap_uint<128>"([32 x i128]* noalias align 512, [32 x %"struct.ap_uint<128>"]* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq [32 x i128]* %0, null
  %3 = icmp eq [32 x %"struct.ap_uint<128>"]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [32 x %"struct.ap_uint<128>"], [32 x %"struct.ap_uint<128>"]* %1, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %5 = getelementptr [32 x i128], [32 x i128]* %0, i64 0, i64 %for.loop.idx7
  %6 = load i128, i128* %src.addr.0.0.05, align 16
  store i128 %6, i128* %5, align 16
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 32
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
define internal fastcc void @copy_out([388800 x %"struct.ap_uint<128>"]* noalias, [388800 x i128]* noalias readonly, [32448 x %"struct.ap_uint<128>"]* noalias, [32448 x i128]* noalias readonly, [388800 x %"struct.ap_uint<128>"]* noalias, [388800 x i128]* noalias readonly, [32 x %"struct.ap_uint<128>"]* noalias, [32 x i128]* noalias readonly align 512, i32* noalias, i32* noalias readonly align 512, i32* noalias, i32* noalias readonly align 512, i32* noalias, i32* noalias readonly align 512, i32* noalias, i32* noalias readonly align 512, i32* noalias, i32* noalias readonly align 512) unnamed_addr #3 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a388800struct.ap_uint<128>"([388800 x %"struct.ap_uint<128>"]* %0, [388800 x i128]* %1)
  call fastcc void @"onebyonecpy_hls.p0a32448struct.ap_uint<128>.150"([32448 x %"struct.ap_uint<128>"]* %2, [32448 x i128]* %3)
  call fastcc void @"onebyonecpy_hls.p0a388800struct.ap_uint<128>"([388800 x %"struct.ap_uint<128>"]* %4, [388800 x i128]* %5)
  call fastcc void @"onebyonecpy_hls.p0a32struct.ap_uint<128>.133"([32 x %"struct.ap_uint<128>"]* %6, [32 x i128]* align 512 %7)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %8, i32* align 512 %9)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %10, i32* align 512 %11)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %12, i32* align 512 %13)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %14, i32* align 512 %15)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %16, i32* align 512 %17)
  ret void
}

declare void @free(i8*) local_unnamed_addr

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a32struct.ap_uint<128>.133"([32 x %"struct.ap_uint<128>"]* noalias, [32 x i128]* noalias readonly align 512) unnamed_addr #2 {
entry:
  %2 = icmp eq [32 x %"struct.ap_uint<128>"]* %0, null
  %3 = icmp eq [32 x i128]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %5 = getelementptr [32 x i128], [32 x i128]* %1, i64 0, i64 %for.loop.idx7
  %dst.addr.0.0.06 = getelementptr [32 x %"struct.ap_uint<128>"], [32 x %"struct.ap_uint<128>"]* %0, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %6 = load i128, i128* %5, align 16
  store i128 %6, i128* %dst.addr.0.0.06, align 16
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 32
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a388800struct.ap_uint<128>.139"([388800 x i128]* noalias, [388800 x %"struct.ap_uint<128>"]* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq [388800 x i128]* %0, null
  %3 = icmp eq [388800 x %"struct.ap_uint<128>"]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [388800 x %"struct.ap_uint<128>"], [388800 x %"struct.ap_uint<128>"]* %1, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %5 = getelementptr [388800 x i128], [388800 x i128]* %0, i64 0, i64 %for.loop.idx7
  %6 = load i128, i128* %src.addr.0.0.05, align 16
  store i128 %6, i128* %5, align 16
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 388800
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a388800struct.ap_uint<128>"([388800 x %"struct.ap_uint<128>"]* noalias, [388800 x i128]* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq [388800 x %"struct.ap_uint<128>"]* %0, null
  %3 = icmp eq [388800 x i128]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %5 = getelementptr [388800 x i128], [388800 x i128]* %1, i64 0, i64 %for.loop.idx7
  %dst.addr.0.0.06 = getelementptr [388800 x %"struct.ap_uint<128>"], [388800 x %"struct.ap_uint<128>"]* %0, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %6 = load i128, i128* %5, align 16
  store i128 %6, i128* %dst.addr.0.0.06, align 16
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 388800
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @"onebyonecpy_hls.p0a32448struct.ap_uint<128>.150"([32448 x %"struct.ap_uint<128>"]* noalias, [32448 x i128]* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq [32448 x %"struct.ap_uint<128>"]* %0, null
  %3 = icmp eq [32448 x i128]* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %copy
  %for.loop.idx7 = phi i64 [ 0, %copy ], [ %for.loop.idx.next, %for.loop ]
  %5 = getelementptr [32448 x i128], [32448 x i128]* %1, i64 0, i64 %for.loop.idx7
  %dst.addr.0.0.06 = getelementptr [32448 x %"struct.ap_uint<128>"], [32448 x %"struct.ap_uint<128>"]* %0, i64 0, i64 %for.loop.idx7, i32 0, i32 0, i32 0
  %6 = load i128, i128* %5, align 16
  store i128 %6, i128* %dst.addr.0.0.06, align 16
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx7, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, 32448
  br i1 %exitcond, label %for.loop, label %ret

ret:                                              ; preds = %for.loop, %entry
  ret void
}

declare i32 @apatb_image_preprocess_hw(i128*, i128*, i128*, i128*, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32*, i32*, i32*, i32*, i32*)

; Function Attrs: argmemonly noinline norecurse
define internal fastcc void @copy_back([388800 x %"struct.ap_uint<128>"]* noalias, [388800 x i128]* noalias readonly, [32448 x %"struct.ap_uint<128>"]* noalias, [32448 x i128]* noalias readonly, [388800 x %"struct.ap_uint<128>"]* noalias, [388800 x i128]* noalias readonly, [32 x %"struct.ap_uint<128>"]* noalias, [32 x i128]* noalias readonly align 512, i32* noalias, i32* noalias readonly align 512, i32* noalias, i32* noalias readonly align 512, i32* noalias, i32* noalias readonly align 512, i32* noalias, i32* noalias readonly align 512, i32* noalias, i32* noalias readonly align 512) unnamed_addr #3 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a32448struct.ap_uint<128>.150"([32448 x %"struct.ap_uint<128>"]* %2, [32448 x i128]* %3)
  call fastcc void @"onebyonecpy_hls.p0a388800struct.ap_uint<128>"([388800 x %"struct.ap_uint<128>"]* %4, [388800 x i128]* %5)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %8, i32* align 512 %9)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %10, i32* align 512 %11)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %12, i32* align 512 %13)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %14, i32* align 512 %15)
  call fastcc void @onebyonecpy_hls.p0i32(i32* %16, i32* align 512 %17)
  ret void
}

define i32 @image_preprocess_hw_stub_wrapper(i128*, i128*, i128*, i128*, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32*, i32*, i32*, i32*, i32*) #4 {
entry:
  %malloccall = tail call i8* @malloc(i64 6220800)
  %26 = bitcast i8* %malloccall to [388800 x %"struct.ap_uint<128>"]*
  %malloccall1 = tail call i8* @malloc(i64 519168)
  %27 = bitcast i8* %malloccall1 to [32448 x %"struct.ap_uint<128>"]*
  %malloccall2 = tail call i8* @malloc(i64 6220800)
  %28 = bitcast i8* %malloccall2 to [388800 x %"struct.ap_uint<128>"]*
  %29 = alloca [32 x %"struct.ap_uint<128>"]
  %30 = bitcast i128* %0 to [388800 x i128]*
  %31 = bitcast i128* %1 to [32448 x i128]*
  %32 = bitcast i128* %2 to [388800 x i128]*
  %33 = bitcast i128* %3 to [32 x i128]*
  call void @copy_out([388800 x %"struct.ap_uint<128>"]* %26, [388800 x i128]* %30, [32448 x %"struct.ap_uint<128>"]* %27, [32448 x i128]* %31, [388800 x %"struct.ap_uint<128>"]* %28, [388800 x i128]* %32, [32 x %"struct.ap_uint<128>"]* %29, [32 x i128]* %33, i32* null, i32* %21, i32* null, i32* %22, i32* null, i32* %23, i32* null, i32* %24, i32* null, i32* %25)
  %34 = bitcast [388800 x %"struct.ap_uint<128>"]* %26 to %"struct.ap_uint<128>"*
  %35 = bitcast [32448 x %"struct.ap_uint<128>"]* %27 to %"struct.ap_uint<128>"*
  %36 = bitcast [388800 x %"struct.ap_uint<128>"]* %28 to %"struct.ap_uint<128>"*
  %37 = bitcast [32 x %"struct.ap_uint<128>"]* %29 to %"struct.ap_uint<128>"*
  %38 = call i32 @image_preprocess_hw_stub(%"struct.ap_uint<128>"* %34, %"struct.ap_uint<128>"* %35, %"struct.ap_uint<128>"* %36, %"struct.ap_uint<128>"* %37, i32 %4, i32 %5, i32 %6, i32 %7, i32 %8, i32 %9, i32 %10, i32 %11, i32 %12, i32 %13, i32 %14, i32 %15, i32 %16, i32 %17, i32 %18, i32 %19, i32 %20, i32* %21, i32* %22, i32* %23, i32* %24, i32* %25)
  call void @copy_in([388800 x %"struct.ap_uint<128>"]* %26, [388800 x i128]* %30, [32448 x %"struct.ap_uint<128>"]* %27, [32448 x i128]* %31, [388800 x %"struct.ap_uint<128>"]* %28, [388800 x i128]* %32, [32 x %"struct.ap_uint<128>"]* %29, [32 x i128]* %33, i32* null, i32* %21, i32* null, i32* %22, i32* null, i32* %23, i32* null, i32* %24, i32* null, i32* %25)
  ret i32 %38
}

declare i32 @image_preprocess_hw_stub(%"struct.ap_uint<128>"*, %"struct.ap_uint<128>"*, %"struct.ap_uint<128>"*, %"struct.ap_uint<128>"*, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32*, i32*, i32*, i32*, i32*)

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
