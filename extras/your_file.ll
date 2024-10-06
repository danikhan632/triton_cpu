; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.3 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@str = private unnamed_addr constant [5 x i8] c"Buzz\00", align 1
@str.4 = private unnamed_addr constant [5 x i8] c"Fizz\00", align 1
@str.5 = private unnamed_addr constant [9 x i8] c"FizzBuzz\00", align 1

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  br label %2

1:                                                ; preds = %20
  ret i32 0

2:                                                ; preds = %0, %20
  %3 = phi i32 [ 1, %0 ], [ %21, %20 ]
  %4 = urem i32 %3, 3
  %5 = urem i32 %3, 5
  %6 = icmp eq i32 %5, 0
  %7 = or i32 %4, %5
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %11

9:                                                ; preds = %2
  %10 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.5)
  br label %20

11:                                               ; preds = %2
  %12 = icmp eq i32 %4, 0
  br i1 %12, label %13, label %15

13:                                               ; preds = %11
  %14 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.4)
  br label %20

15:                                               ; preds = %11
  br i1 %6, label %16, label %18

16:                                               ; preds = %15
  %17 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str)
  br label %20

18:                                               ; preds = %15
  %19 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.3, i32 noundef %3)
  br label %20

20:                                               ; preds = %9, %16, %18, %13
  %21 = add nuw nsw i32 %3, 1
  %22 = icmp eq i32 %21, 101
  br i1 %22, label %1, label %2, !llvm.loop !5
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #1

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr nocapture noundef readonly) local_unnamed_addr #2

attributes #0 = { nofree nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 16.0.6 (15)"}
!5 = distinct !{!5, !6, !7}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!"llvm.loop.unroll.disable"}
