; ModuleID = 'Test.c'
source_filename = "Test.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

; Function Attrs: norecurse nounwind uwtable
define void @init(float* nocapture, float* nocapture, float* nocapture, i64) local_unnamed_addr #0 {
  %5 = icmp eq i64 %3, 0
  br i1 %5, label %25, label %6

; <label>:6:                                      ; preds = %4
  %7 = shl i64 %3, 1
  %8 = and i64 %3, 1
  %9 = icmp eq i64 %3, 1
  br i1 %9, label %12, label %10

; <label>:10:                                     ; preds = %6
  %11 = sub i64 %3, %8
  br label %26

; <label>:12:                                     ; preds = %26, %6
  %13 = phi i64 [ 0, %6 ], [ %48, %26 ]
  %14 = icmp eq i64 %8, 0
  br i1 %14, label %25, label %15

; <label>:15:                                     ; preds = %12
  %16 = sub i64 %3, %13
  %17 = uitofp i64 %16 to float
  %18 = getelementptr inbounds float, float* %0, i64 %13
  store float %17, float* %18, align 4, !tbaa !2
  %19 = add i64 %13, %7
  %20 = uitofp i64 %19 to float
  %21 = getelementptr inbounds float, float* %1, i64 %13
  store float %20, float* %21, align 4, !tbaa !2
  %22 = add i64 %13, %3
  %23 = uitofp i64 %22 to float
  %24 = getelementptr inbounds float, float* %2, i64 %13
  store float %23, float* %24, align 4, !tbaa !2
  br label %25

; <label>:25:                                     ; preds = %15, %12, %4
  ret void

; <label>:26:                                     ; preds = %26, %10
  %27 = phi i64 [ 0, %10 ], [ %48, %26 ]
  %28 = phi i64 [ %11, %10 ], [ %49, %26 ]
  %29 = sub i64 %3, %27
  %30 = uitofp i64 %29 to float
  %31 = getelementptr inbounds float, float* %0, i64 %27
  store float %30, float* %31, align 4, !tbaa !2
  %32 = add i64 %27, %7
  %33 = uitofp i64 %32 to float
  %34 = getelementptr inbounds float, float* %1, i64 %27
  store float %33, float* %34, align 4, !tbaa !2
  %35 = add i64 %27, %3
  %36 = uitofp i64 %35 to float
  %37 = getelementptr inbounds float, float* %2, i64 %27
  store float %36, float* %37, align 4, !tbaa !2
  %38 = or i64 %27, 1
  %39 = sub i64 %3, %38
  %40 = uitofp i64 %39 to float
  %41 = getelementptr inbounds float, float* %0, i64 %38
  store float %40, float* %41, align 4, !tbaa !2
  %42 = add i64 %38, %7
  %43 = uitofp i64 %42 to float
  %44 = getelementptr inbounds float, float* %1, i64 %38
  store float %43, float* %44, align 4, !tbaa !2
  %45 = add i64 %38, %3
  %46 = uitofp i64 %45 to float
  %47 = getelementptr inbounds float, float* %2, i64 %38
  store float %46, float* %47, align 4, !tbaa !2
  %48 = add i64 %27, 2
  %49 = add i64 %28, -2
  %50 = icmp eq i64 %49, 0
  br i1 %50, label %12, label %26
}

; Function Attrs: norecurse nounwind uwtable
define void @VectorAdd(float* nocapture readonly, float* nocapture readonly, float* nocapture, i64) local_unnamed_addr #0 {
  %5 = icmp eq i64 %3, 0
  br i1 %5, label %89, label %6

; <label>:6:                                      ; preds = %4
  %7 = icmp ult i64 %3, 4
  br i1 %7, label %8, label %26

; <label>:8:                                      ; preds = %87, %26, %6
  %9 = phi i64 [ 0, %26 ], [ 0, %6 ], [ %38, %87 ]
  %10 = add i64 %3, -1
  %11 = and i64 %3, 1
  %12 = icmp eq i64 %11, 0
  br i1 %12, label %22, label %13

; <label>:13:                                     ; preds = %8
  %14 = getelementptr inbounds float, float* %0, i64 %9
  %15 = load float, float* %14, align 4, !tbaa !2
  %16 = getelementptr inbounds float, float* %1, i64 %9
  %17 = load float, float* %16, align 4, !tbaa !2
  %18 = fadd float %15, %17
  %19 = fdiv float %18, %15
  %20 = getelementptr inbounds float, float* %2, i64 %9
  store float %19, float* %20, align 4, !tbaa !2
  %21 = or i64 %9, 1
  br label %22

; <label>:22:                                     ; preds = %8, %13
  %23 = phi i64 [ %9, %8 ], [ %21, %13 ]
  %24 = icmp eq i64 %10, %9
  br i1 %24, label %89, label %25

; <label>:25:                                     ; preds = %22
  br label %90

; <label>:26:                                     ; preds = %6
  %27 = getelementptr float, float* %2, i64 %3
  %28 = getelementptr float, float* %0, i64 %3
  %29 = getelementptr float, float* %1, i64 %3
  %30 = icmp ugt float* %28, %2
  %31 = icmp ugt float* %27, %0
  %32 = and i1 %30, %31
  %33 = icmp ugt float* %29, %2
  %34 = icmp ugt float* %27, %1
  %35 = and i1 %33, %34
  %36 = or i1 %32, %35
  br i1 %36, label %8, label %37

; <label>:37:                                     ; preds = %26
  %38 = and i64 %3, -4
  %39 = add i64 %38, -4
  %40 = lshr exact i64 %39, 2
  %41 = add nuw nsw i64 %40, 1
  %42 = and i64 %41, 1
  %43 = icmp eq i64 %39, 0
  br i1 %43, label %73, label %44

; <label>:44:                                     ; preds = %37
  %45 = sub nsw i64 %41, %42
  br label %46

; <label>:46:                                     ; preds = %46, %44
  %47 = phi i64 [ 0, %44 ], [ %70, %46 ]
  %48 = phi i64 [ %45, %44 ], [ %71, %46 ]
  %49 = getelementptr inbounds float, float* %0, i64 %47
  %50 = bitcast float* %49 to <4 x float>*
  %51 = load <4 x float>, <4 x float>* %50, align 4, !tbaa !2, !alias.scope !6
  %52 = getelementptr inbounds float, float* %1, i64 %47
  %53 = bitcast float* %52 to <4 x float>*
  %54 = load <4 x float>, <4 x float>* %53, align 4, !tbaa !2, !alias.scope !9
  %55 = fadd <4 x float> %51, %54
  %56 = fdiv <4 x float> %55, %51
  %57 = getelementptr inbounds float, float* %2, i64 %47
  %58 = bitcast float* %57 to <4 x float>*
  store <4 x float> %56, <4 x float>* %58, align 4, !tbaa !2, !alias.scope !11, !noalias !13
  %59 = or i64 %47, 4
  %60 = getelementptr inbounds float, float* %0, i64 %59
  %61 = bitcast float* %60 to <4 x float>*
  %62 = load <4 x float>, <4 x float>* %61, align 4, !tbaa !2, !alias.scope !6
  %63 = getelementptr inbounds float, float* %1, i64 %59
  %64 = bitcast float* %63 to <4 x float>*
  %65 = load <4 x float>, <4 x float>* %64, align 4, !tbaa !2, !alias.scope !9
  %66 = fadd <4 x float> %62, %65
  %67 = fdiv <4 x float> %66, %62
  %68 = getelementptr inbounds float, float* %2, i64 %59
  %69 = bitcast float* %68 to <4 x float>*
  store <4 x float> %67, <4 x float>* %69, align 4, !tbaa !2, !alias.scope !11, !noalias !13
  %70 = add i64 %47, 8
  %71 = add i64 %48, -2
  %72 = icmp eq i64 %71, 0
  br i1 %72, label %73, label %46, !llvm.loop !14

; <label>:73:                                     ; preds = %46, %37
  %74 = phi i64 [ 0, %37 ], [ %70, %46 ]
  %75 = icmp eq i64 %42, 0
  br i1 %75, label %87, label %76

; <label>:76:                                     ; preds = %73
  %77 = getelementptr inbounds float, float* %0, i64 %74
  %78 = bitcast float* %77 to <4 x float>*
  %79 = load <4 x float>, <4 x float>* %78, align 4, !tbaa !2, !alias.scope !6
  %80 = getelementptr inbounds float, float* %1, i64 %74
  %81 = bitcast float* %80 to <4 x float>*
  %82 = load <4 x float>, <4 x float>* %81, align 4, !tbaa !2, !alias.scope !9
  %83 = fadd <4 x float> %79, %82
  %84 = fdiv <4 x float> %83, %79
  %85 = getelementptr inbounds float, float* %2, i64 %74
  %86 = bitcast float* %85 to <4 x float>*
  store <4 x float> %84, <4 x float>* %86, align 4, !tbaa !2, !alias.scope !11, !noalias !13
  br label %87

; <label>:87:                                     ; preds = %73, %76
  %88 = icmp eq i64 %38, %3
  br i1 %88, label %89, label %8

; <label>:89:                                     ; preds = %22, %90, %87, %4
  ret void

; <label>:90:                                     ; preds = %90, %25
  %91 = phi i64 [ %23, %25 ], [ %107, %90 ]
  %92 = getelementptr inbounds float, float* %0, i64 %91
  %93 = load float, float* %92, align 4, !tbaa !2
  %94 = getelementptr inbounds float, float* %1, i64 %91
  %95 = load float, float* %94, align 4, !tbaa !2
  %96 = fadd float %93, %95
  %97 = fdiv float %96, %93
  %98 = getelementptr inbounds float, float* %2, i64 %91
  store float %97, float* %98, align 4, !tbaa !2
  %99 = add nuw i64 %91, 1
  %100 = getelementptr inbounds float, float* %0, i64 %99
  %101 = load float, float* %100, align 4, !tbaa !2
  %102 = getelementptr inbounds float, float* %1, i64 %99
  %103 = load float, float* %102, align 4, !tbaa !2
  %104 = fadd float %101, %103
  %105 = fdiv float %104, %101
  %106 = getelementptr inbounds float, float* %2, i64 %99
  store float %105, float* %106, align 4, !tbaa !2
  %107 = add i64 %91, 2
  %108 = icmp eq i64 %107, %3
  br i1 %108, label %89, label %90, !llvm.loop !16
}

; Function Attrs: norecurse nounwind uwtable
define void @FuseAddMul(float* nocapture readonly, float* nocapture readonly, float* nocapture, i64) local_unnamed_addr #0 {
  %5 = icmp eq i64 %3, 0
  br i1 %5, label %132, label %6

; <label>:6:                                      ; preds = %4
  %7 = icmp ult i64 %3, 8
  br i1 %7, label %8, label %27

; <label>:8:                                      ; preds = %130, %27, %6
  %9 = phi i64 [ 0, %27 ], [ 0, %6 ], [ %39, %130 ]
  %10 = add i64 %3, -1
  %11 = and i64 %3, 1
  %12 = icmp eq i64 %11, 0
  br i1 %12, label %23, label %13

; <label>:13:                                     ; preds = %8
  %14 = getelementptr inbounds float, float* %0, i64 %9
  %15 = load float, float* %14, align 4, !tbaa !2
  %16 = getelementptr inbounds float, float* %1, i64 %9
  %17 = load float, float* %16, align 4, !tbaa !2
  %18 = fmul float %15, %17
  %19 = getelementptr inbounds float, float* %2, i64 %9
  %20 = load float, float* %19, align 4, !tbaa !2
  %21 = fadd float %18, %20
  store float %21, float* %19, align 4, !tbaa !2
  %22 = or i64 %9, 1
  br label %23

; <label>:23:                                     ; preds = %8, %13
  %24 = phi i64 [ %9, %8 ], [ %22, %13 ]
  %25 = icmp eq i64 %10, %9
  br i1 %25, label %132, label %26

; <label>:26:                                     ; preds = %23
  br label %133

; <label>:27:                                     ; preds = %6
  %28 = getelementptr float, float* %2, i64 %3
  %29 = getelementptr float, float* %0, i64 %3
  %30 = getelementptr float, float* %1, i64 %3
  %31 = icmp ugt float* %29, %2
  %32 = icmp ugt float* %28, %0
  %33 = and i1 %31, %32
  %34 = icmp ugt float* %30, %2
  %35 = icmp ugt float* %28, %1
  %36 = and i1 %34, %35
  %37 = or i1 %33, %36
  br i1 %37, label %8, label %38

; <label>:38:                                     ; preds = %27
  %39 = and i64 %3, -8
  %40 = add i64 %39, -8
  %41 = lshr exact i64 %40, 3
  %42 = add nuw nsw i64 %41, 1
  %43 = and i64 %42, 1
  %44 = icmp eq i64 %40, 0
  br i1 %44, label %102, label %45

; <label>:45:                                     ; preds = %38
  %46 = sub nsw i64 %42, %43
  br label %47

; <label>:47:                                     ; preds = %47, %45
  %48 = phi i64 [ 0, %45 ], [ %99, %47 ]
  %49 = phi i64 [ %46, %45 ], [ %100, %47 ]
  %50 = getelementptr inbounds float, float* %0, i64 %48
  %51 = bitcast float* %50 to <4 x float>*
  %52 = load <4 x float>, <4 x float>* %51, align 4, !tbaa !2, !alias.scope !17
  %53 = getelementptr float, float* %50, i64 4
  %54 = bitcast float* %53 to <4 x float>*
  %55 = load <4 x float>, <4 x float>* %54, align 4, !tbaa !2, !alias.scope !17
  %56 = getelementptr inbounds float, float* %1, i64 %48
  %57 = bitcast float* %56 to <4 x float>*
  %58 = load <4 x float>, <4 x float>* %57, align 4, !tbaa !2, !alias.scope !20
  %59 = getelementptr float, float* %56, i64 4
  %60 = bitcast float* %59 to <4 x float>*
  %61 = load <4 x float>, <4 x float>* %60, align 4, !tbaa !2, !alias.scope !20
  %62 = fmul <4 x float> %52, %58
  %63 = fmul <4 x float> %55, %61
  %64 = getelementptr inbounds float, float* %2, i64 %48
  %65 = bitcast float* %64 to <4 x float>*
  %66 = load <4 x float>, <4 x float>* %65, align 4, !tbaa !2, !alias.scope !22, !noalias !24
  %67 = getelementptr float, float* %64, i64 4
  %68 = bitcast float* %67 to <4 x float>*
  %69 = load <4 x float>, <4 x float>* %68, align 4, !tbaa !2, !alias.scope !22, !noalias !24
  %70 = fadd <4 x float> %62, %66
  %71 = fadd <4 x float> %63, %69
  %72 = bitcast float* %64 to <4 x float>*
  store <4 x float> %70, <4 x float>* %72, align 4, !tbaa !2, !alias.scope !22, !noalias !24
  %73 = bitcast float* %67 to <4 x float>*
  store <4 x float> %71, <4 x float>* %73, align 4, !tbaa !2, !alias.scope !22, !noalias !24
  %74 = or i64 %48, 8
  %75 = getelementptr inbounds float, float* %0, i64 %74
  %76 = bitcast float* %75 to <4 x float>*
  %77 = load <4 x float>, <4 x float>* %76, align 4, !tbaa !2, !alias.scope !17
  %78 = getelementptr float, float* %75, i64 4
  %79 = bitcast float* %78 to <4 x float>*
  %80 = load <4 x float>, <4 x float>* %79, align 4, !tbaa !2, !alias.scope !17
  %81 = getelementptr inbounds float, float* %1, i64 %74
  %82 = bitcast float* %81 to <4 x float>*
  %83 = load <4 x float>, <4 x float>* %82, align 4, !tbaa !2, !alias.scope !20
  %84 = getelementptr float, float* %81, i64 4
  %85 = bitcast float* %84 to <4 x float>*
  %86 = load <4 x float>, <4 x float>* %85, align 4, !tbaa !2, !alias.scope !20
  %87 = fmul <4 x float> %77, %83
  %88 = fmul <4 x float> %80, %86
  %89 = getelementptr inbounds float, float* %2, i64 %74
  %90 = bitcast float* %89 to <4 x float>*
  %91 = load <4 x float>, <4 x float>* %90, align 4, !tbaa !2, !alias.scope !22, !noalias !24
  %92 = getelementptr float, float* %89, i64 4
  %93 = bitcast float* %92 to <4 x float>*
  %94 = load <4 x float>, <4 x float>* %93, align 4, !tbaa !2, !alias.scope !22, !noalias !24
  %95 = fadd <4 x float> %87, %91
  %96 = fadd <4 x float> %88, %94
  %97 = bitcast float* %89 to <4 x float>*
  store <4 x float> %95, <4 x float>* %97, align 4, !tbaa !2, !alias.scope !22, !noalias !24
  %98 = bitcast float* %92 to <4 x float>*
  store <4 x float> %96, <4 x float>* %98, align 4, !tbaa !2, !alias.scope !22, !noalias !24
  %99 = add i64 %48, 16
  %100 = add i64 %49, -2
  %101 = icmp eq i64 %100, 0
  br i1 %101, label %102, label %47, !llvm.loop !25

; <label>:102:                                    ; preds = %47, %38
  %103 = phi i64 [ 0, %38 ], [ %99, %47 ]
  %104 = icmp eq i64 %43, 0
  br i1 %104, label %130, label %105

; <label>:105:                                    ; preds = %102
  %106 = getelementptr inbounds float, float* %0, i64 %103
  %107 = bitcast float* %106 to <4 x float>*
  %108 = load <4 x float>, <4 x float>* %107, align 4, !tbaa !2, !alias.scope !17
  %109 = getelementptr float, float* %106, i64 4
  %110 = bitcast float* %109 to <4 x float>*
  %111 = load <4 x float>, <4 x float>* %110, align 4, !tbaa !2, !alias.scope !17
  %112 = getelementptr inbounds float, float* %1, i64 %103
  %113 = bitcast float* %112 to <4 x float>*
  %114 = load <4 x float>, <4 x float>* %113, align 4, !tbaa !2, !alias.scope !20
  %115 = getelementptr float, float* %112, i64 4
  %116 = bitcast float* %115 to <4 x float>*
  %117 = load <4 x float>, <4 x float>* %116, align 4, !tbaa !2, !alias.scope !20
  %118 = fmul <4 x float> %108, %114
  %119 = fmul <4 x float> %111, %117
  %120 = getelementptr inbounds float, float* %2, i64 %103
  %121 = bitcast float* %120 to <4 x float>*
  %122 = load <4 x float>, <4 x float>* %121, align 4, !tbaa !2, !alias.scope !22, !noalias !24
  %123 = getelementptr float, float* %120, i64 4
  %124 = bitcast float* %123 to <4 x float>*
  %125 = load <4 x float>, <4 x float>* %124, align 4, !tbaa !2, !alias.scope !22, !noalias !24
  %126 = fadd <4 x float> %118, %122
  %127 = fadd <4 x float> %119, %125
  %128 = bitcast float* %120 to <4 x float>*
  store <4 x float> %126, <4 x float>* %128, align 4, !tbaa !2, !alias.scope !22, !noalias !24
  %129 = bitcast float* %123 to <4 x float>*
  store <4 x float> %127, <4 x float>* %129, align 4, !tbaa !2, !alias.scope !22, !noalias !24
  br label %130

; <label>:130:                                    ; preds = %102, %105
  %131 = icmp eq i64 %39, %3
  br i1 %131, label %132, label %8

; <label>:132:                                    ; preds = %23, %133, %130, %4
  ret void

; <label>:133:                                    ; preds = %133, %26
  %134 = phi i64 [ %24, %26 ], [ %152, %133 ]
  %135 = getelementptr inbounds float, float* %0, i64 %134
  %136 = load float, float* %135, align 4, !tbaa !2
  %137 = getelementptr inbounds float, float* %1, i64 %134
  %138 = load float, float* %137, align 4, !tbaa !2
  %139 = fmul float %136, %138
  %140 = getelementptr inbounds float, float* %2, i64 %134
  %141 = load float, float* %140, align 4, !tbaa !2
  %142 = fadd float %139, %141
  store float %142, float* %140, align 4, !tbaa !2
  %143 = add nuw i64 %134, 1
  %144 = getelementptr inbounds float, float* %0, i64 %143
  %145 = load float, float* %144, align 4, !tbaa !2
  %146 = getelementptr inbounds float, float* %1, i64 %143
  %147 = load float, float* %146, align 4, !tbaa !2
  %148 = fmul float %145, %147
  %149 = getelementptr inbounds float, float* %2, i64 %143
  %150 = load float, float* %149, align 4, !tbaa !2
  %151 = fadd float %148, %150
  store float %151, float* %149, align 4, !tbaa !2
  %152 = add i64 %134, 2
  %153 = icmp eq i64 %152, %3
  br i1 %153, label %132, label %133, !llvm.loop !26
}

; Function Attrs: nounwind uwtable
define i32 @main() local_unnamed_addr #1 {
  %1 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), double 2.030000e+02)
  %2 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), double 0x40680AAAA0000000)
  %3 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), double 1.797500e+02)
  %4 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), double 0x4064A924A0000000)
  %5 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), double 1.490000e+02)
  %6 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), double 1.310000e+02)
  %7 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), double 1.115000e+02)
  %8 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), double 9.100000e+01)
  %9 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), double 7.100000e+01)
  %10 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), double 5.900000e+01)
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @printf(i8* nocapture readonly, ...) local_unnamed_addr #2

attributes #0 = { norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!2 = !{!3, !3, i64 0}
!3 = !{!"float", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!7}
!7 = distinct !{!7, !8}
!8 = distinct !{!8, !"LVerDomain"}
!9 = !{!10}
!10 = distinct !{!10, !8}
!11 = !{!12}
!12 = distinct !{!12, !8}
!13 = !{!7, !10}
!14 = distinct !{!14, !15}
!15 = !{!"llvm.loop.isvectorized", i32 1}
!16 = distinct !{!16, !15}
!17 = !{!18}
!18 = distinct !{!18, !19}
!19 = distinct !{!19, !"LVerDomain"}
!20 = !{!21}
!21 = distinct !{!21, !19}
!22 = !{!23}
!23 = distinct !{!23, !19}
!24 = !{!18, !21}
!25 = distinct !{!25, !15}
!26 = distinct !{!26, !15}
