(in-package :rtg-math.matrix3)

;; All matrices are stored in column-major format, but when you
;; write them (like in m!) then you write them in row-major format.

;;----------------------------------------------------------------

(defn-inline 0! () mat3
  (declare (optimize (speed 3) (safety 0) (debug 0)))
  (make-array 9 :element-type `single-float :initial-element 0.0))

;;----------------------------------------------------------------

(defn make ((a single-float) (b single-float) (c single-float)
             (d single-float) (e single-float) (f single-float)
             (g single-float) (h single-float) (i single-float)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline 0!))
  (m3-n:set-components a b c d e f g h i (0!)))

;;----------------------------------------------------------------

(defn-inline copy-mat3 ((mat3 mat3)) mat3
  (declare (optimize (speed 3) (safety 0) (debug 1)))
  (let ((result (make-array 9 :element-type 'single-float)))
    (dotimes (i 9)
      (setf (aref result i) (aref mat3 i)))
    result))

;;----------------------------------------------------------------

(defn identity () mat3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (make
   1.0 0.0 0.0
   0.0 1.0 0.0
   0.0 0.0 1.0))

;;----------------------------------------------------------------

(defn from-rows ((row-1 vec3) (row-2 vec3) (row-3 vec3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (make (x row-1) (y row-1) (z row-1)
        (x row-2) (y row-2) (z row-2)
        (x row-3) (y row-3) (z row-3)))

;;----------------------------------------------------------------

(defn get-rows ((mat-a mat3)) list
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (list (v3:make (melm mat-a 0 0)
                 (melm mat-a 0 1)
                 (melm mat-a 0 2))
        (v3:make (melm mat-a 1 0)
                 (melm mat-a 1 1)
                 (melm mat-a 1 2))
        (v3:make (melm mat-a 2 0)
                 (melm mat-a 2 1)
                 (melm mat-a 2 2))))

;;----------------------------------------------------------------

(defn get-row ((mat-a mat3) (row-num (integer 0 3))) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (v3:make (melm mat-a row-num 0)
           (melm mat-a row-num 1)
           (melm mat-a row-num 2)))

;;----------------------------------------------------------------

(defn from-columns ((col-1 vec3) (col-2 vec3) (col-3 vec3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (make (x col-1) (x col-2) (x col-3)
        (y col-1) (y col-2) (y col-3)
        (z col-1) (z col-2) (z col-3)))

;;----------------------------------------------------------------


(defn get-columns ((mat-a mat3)) list
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (list (v! (melm mat-a 0 0)
            (melm mat-a 1 0)
            (melm mat-a 2 0))
        (v! (melm mat-a 0 1)
            (melm mat-a 1 1)
            (melm mat-a 2 1))
        (v! (melm mat-a 0 2)
            (melm mat-a 1 2)
            (melm mat-a 2 2))))

;;----------------------------------------------------------------

(defn get-column ((mat-a mat3) (col-num (integer 0 3))) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (v3:make (melm mat-a 0 col-num)
           (melm mat-a 1 col-num)
           (melm mat-a 2 col-num)))

;;----------------------------------------------------------------

(defn 0p ((mat-a mat3)) boolean
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (loop :for i :below 9 :always (cl:= 0f0 (aref mat-a i))))

;;----------------------------------------------------------------

(defn identityp ((mat-a mat3)) boolean
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (and (cl:= 0f0 (cl:- (melm mat-a 0 0) 1.0))
       (cl:= 0f0 (cl:- (melm mat-a 1 1) 1.0))
       (cl:= 0f0 (cl:- (melm mat-a 2 2) 1.0))
       (cl:= 0f0 (melm mat-a 0 1))
       (cl:= 0f0 (melm mat-a 0 2))
       (cl:= 0f0 (melm mat-a 1 0))
       (cl:= 0f0 (melm mat-a 1 2))
       (cl:= 0f0 (melm mat-a 2 0))
       (cl:= 0f0 (melm mat-a 2 1))))

;;----------------------------------------------------------------

(defn = ((mat-a mat3) (mat-b mat3)) boolean
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (and (cl:= (aref mat-a 0) (aref mat-b 0))
       (cl:= (aref mat-a 1) (aref mat-b 1))
       (cl:= (aref mat-a 2) (aref mat-b 2))
       (cl:= (aref mat-a 3) (aref mat-b 3))
       (cl:= (aref mat-a 4) (aref mat-b 4))
       (cl:= (aref mat-a 5) (aref mat-b 5))
       (cl:= (aref mat-a 6) (aref mat-b 6))
       (cl:= (aref mat-a 7) (aref mat-b 7))
       (cl:= (aref mat-a 8) (aref mat-b 8))))

;;----------------------------------------------------------------

(defn determinant ((mat-a mat3)) single-float
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (let* ((cofactor-0 (cl:- (cl:* (melm mat-a 1 1) (melm mat-a 2 2))
                           (cl:* (melm mat-a 2 1) (melm mat-a 1 2))))

         (cofactor-3 (cl:- (cl:* (melm mat-a 2 0) (melm mat-a 1 2))
                           (cl:* (melm mat-a 1 0) (melm mat-a 2 2))))

         (cofactor-6 (cl:- (cl:* (melm mat-a 1 0) (melm mat-a 2 1))
                           (cl:* (melm mat-a 2 0) (melm mat-a 1 1)))))
    (cl:+ (cl:* (melm mat-a 0 0) cofactor-0)
          (cl:* (melm mat-a 0 1) cofactor-3)
          (cl:* (melm mat-a 0 2) cofactor-6))))

;;----------------------------------------------------------------

(defn affine-inverse ((mat-a mat3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline copy-mat3))
  (m3-n:affine-inverse (copy-mat3 mat-a)))

;;----------------------------------------------------------------

(defn transpose ((mat-a mat3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline copy-mat3))
  (m3-n:transpose (copy-mat3 mat-a)))

;;----------------------------------------------------------------

(defn adjoint ((mat-a mat3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline copy-mat3))
  (m3-n:adjoint (copy-mat3 mat-a)))

;;----------------------------------------------------------------

(defn trace ((mat-a mat3)) single-float
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (cl:+ (melm mat-a 0 0) (melm mat-a 1 1) (melm mat-a 2 2)))

;;----------------------------------------------------------------

;;Rotation goes here, requires quaternion

;;----------------------------------------------------------------

(defn rotation-from-euler ((vec3-a vec3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline 0!))
  (m3-n:set-rotation-from-euler (0!) vec3-a))

;;----------------------------------------------------------------

(defn scale ((scale-vec3 vec3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline 0!))
  (m3-n:set-from-scale (0!) scale-vec3))

;;----------------------------------------------------------------

(defn rotation-x ((angle single-float)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline 0!))
  (m3-n:set-from-rotation-x (0!) angle))

;;----------------------------------------------------------------

(defn rotation-y ((angle single-float)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline 0!))
  (m3-n:set-from-rotation-y (0!) angle))

;;----------------------------------------------------------------

(defn rotation-z ((angle single-float)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline 0!))
  (m3-n:set-from-rotation-z (0!) angle))

;;----------------------------------------------------------------

(defn rotation-from-axis-angle ((axis3 vec3) (angle single-float)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline 0!))
  (m3-n:set-rotation-from-axis-angle (0!) axis3 angle))

;;----------------------------------------------------------------

(defn get-fixed-angles ((mat-a mat3)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (let* ((sy (melm mat-a 0 2)))
    (declare ((single-float -1f0 1f0) sy))
    (let ((cy (sqrt (cl:- 1f0 (cl:* sy sy)))))
      (declare (single-float cy))
      (if (not (cl:= 0f0 cy)) ; [TODO: not correct PI-epsilon]
          (let* ((factor (cl:/ 1.0 cy))
                 (sx (cl:* factor (cl:- (melm mat-a 2 1))))
                 (cx (cl:* factor (melm mat-a 2 2)))
                 (sz (cl:* factor (cl:- (melm mat-a 1 0))))
                 (cz (cl:* factor (melm mat-a 0 0))))
            (v3:make (atan sx cx) (atan sy cy) (atan sz cz)))
          (let* ((sz 0.0)
                 (cx 1.0)
                 (sx (melm mat-a 1 2))
                 (cz (melm mat-a 1 1)))
            (v3:make (atan sx cx) (atan sy cy) (atan sz cz)))))))

;;----------------------------------------------------------------

;; [TODO] find out how we can declaim angle to be float
;; [TODO] Comment the fuck out of this and work out how it works
(defn get-axis-angle ((mat-a mat3)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (let* ((c-a (cl:* 0.5 (cl:- (trace mat-a) 1.0))))
    (declare (type (single-float -1f0 1f0) c-a))
    (let ((angle (acos c-a)))
      (cond ((cl:= 0f0 angle) ;; <-angle is zero so axis can be anything
             (v! 1.0 0.0 0.0))
            ((< angle rtg-math.base-maths:+pi+)
                                        ;its not 180 degrees
             (let ((axis (v! (cl:- (melm mat-a 1 2) (melm mat-a 2 1))
                             (cl:- (melm mat-a 2 0) (melm mat-a 0 2))
                             (cl:- (melm mat-a 0 1) (melm mat-a 1 0)))))
               (v3-n:normalize axis)))
            (t (let* ((i (if (> (melm mat-a 1 1) (melm mat-a 0 0))
                             1
                             (if (> (melm mat-a 2 2)
                                    (melm mat-a 0 0))
                                 2
                                 0)))
                      (j (mod (cl:+ i 1) 3))
                      (k (mod (cl:+ j 1) 3))
                      (tmp-s (cl:+ 1.0 (cl:- (melm mat-a i i)
                                             (melm mat-a j j)
                                             (melm mat-a k k))))
                      (s (sqrt (the (single-float 0f0 #.most-positive-single-float)
                                    tmp-s)))
                      (recip (cl:/ 1.0 s))
                      (result (v! 0.0 0.0 0.0)))
                 (setf (aref result i) (cl:* 0.5 s))
                 (setf (aref result j) (cl:* recip (melm mat-a i j)))
                 (setf (aref result j) (cl:* recip (melm mat-a k i)))
                 result))))))

;;----------------------------------------------------------------

(defn + ((mat-a mat3) (mat-b mat3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline 0!))
  (let ((r (0!)))
    (declare (mat3 r))
    (loop :for i :below 9 :do
       (setf (aref r i) (cl:+ (aref mat-a i) (aref mat-b i))))
    r))

;;----------------------------------------------------------------

(defn - ((mat-a mat3) (mat-b mat3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline 0!))
  (let ((r (0!)))
    (declare (mat3 r))
    (loop :for i :below 9 :do
       (setf (aref r i) (cl:- (aref mat-a i) (aref mat-b i))))
    r))

;;----------------------------------------------------------------

(defn negate ((mat-a mat3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline copy-mat3))
  (m3-n:negate (copy-mat3 mat-a)))

;;----------------------------------------------------------------

(defn *v ((mat-a mat3) (vec-a vec3)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (m3-n:*v mat-a (v3:copy-vec3 vec-a)))

;;----------------------------------------------------------------

(defn mrow*vec3 ((vec vec3) (mat-a mat3)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (m3-n:mrow*vec3 (v3:copy-vec3 vec) mat-a))

;;----------------------------------------------------------------

(defn %* ((mat-a mat3) (mat-b mat3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (make (cl:+ (cl:* (melm mat-a 0 0) (melm mat-b 0 0))
              (cl:* (melm mat-a 0 1) (melm mat-b 1 0))
              (cl:* (melm mat-a 0 2) (melm mat-b 2 0)))
        (cl:+ (cl:* (melm mat-a 0 0) (melm mat-b 0 1))
              (cl:* (melm mat-a 0 1) (melm mat-b 1 1))
              (cl:* (melm mat-a 0 2) (melm mat-b 2 1)))
        (cl:+ (cl:* (melm mat-a 0 0) (melm mat-b 0 2))
              (cl:* (melm mat-a 0 1) (melm mat-b 1 2))
              (cl:* (melm mat-a 0 2) (melm mat-b 2 2)))
        (cl:+ (cl:* (melm mat-a 1 0) (melm mat-b 0 0))
              (cl:* (melm mat-a 1 1) (melm mat-b 1 0))
              (cl:* (melm mat-a 1 2) (melm mat-b 2 0)))
        (cl:+ (cl:* (melm mat-a 1 0) (melm mat-b 0 1))
              (cl:* (melm mat-a 1 1) (melm mat-b 1 1))
              (cl:* (melm mat-a 1 2) (melm mat-b 2 1)))
        (cl:+ (cl:* (melm mat-a 1 0) (melm mat-b 0 2))
              (cl:* (melm mat-a 1 1) (melm mat-b 1 2))
              (cl:* (melm mat-a 1 2) (melm mat-b 2 2)))
        (cl:+ (cl:* (melm mat-a 2 0) (melm mat-b 0 0))
              (cl:* (melm mat-a 2 1) (melm mat-b 1 0))
              (cl:* (melm mat-a 2 2) (melm mat-b 2 0)))
        (cl:+ (cl:* (melm mat-a 2 0) (melm mat-b 0 1))
              (cl:* (melm mat-a 2 1) (melm mat-b 1 1))
              (cl:* (melm mat-a 2 2) (melm mat-b 2 1)))
        (cl:+ (cl:* (melm mat-a 2 0) (melm mat-b 0 2))
              (cl:* (melm mat-a 2 1) (melm mat-b 1 2))
              (cl:* (melm mat-a 2 2) (melm mat-b 2 2)))))

(defn * (&rest (matrices mat3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (if matrices
      (reduce #'m3-n::%* matrices :initial-value (identity))
      (identity)))

(define-compiler-macro * (&whole whole &rest matrices)
  (case= (length matrices)
    (0 `(identity))
    (1 (first matrices))
    (2 `(%* ,@matrices))
    (otherwise whole)))

;;----------------------------------------------------------------

(defn *s ((mat-a mat3) (scalar single-float)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline copy-mat3))
  (m3-n:*s (copy-mat3 mat-a) scalar))

;;----------------------------------------------------------------
;; makes a matrix to orient something towards a point

(defn-inline from-direction ((up3 vec3) (dir3 vec3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (let* ((zaxis (v3:normalize dir3))
         (xaxis (v3-n:normalize (v3:cross zaxis up3)))
         (yaxis (v3:cross xaxis zaxis)))
    (m3:make (x xaxis) (x yaxis) (cl:- (x zaxis))
             (y xaxis) (y yaxis) (cl:- (y zaxis))
             (z xaxis) (z yaxis) (cl:- (z zaxis)))))

;;----------------------------------------------------------------
;; makes a matrix to orient something at a point towards another point

(defn point-at ((up vec3) (from3 vec3) (to3 vec3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1))
           (inline from-direction))
  (from-direction up (v3:- to3 from3)))

;;----------------------------------------------------------------
;; Makes the rotation portion of a world->view look-at matrix

(defn-inline look-at ((up3 vec3) (from3 vec3) (to3 vec3)) mat3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (let* ((zaxis (v3-n:normalize (v3:- to3 from3)))
         (xaxis (v3-n:normalize (v3:cross zaxis up3)))
         (yaxis (v3:cross xaxis zaxis)))
    (m3:make (x xaxis) (y xaxis) (z xaxis)
             (x yaxis) (y yaxis) (z yaxis)
             (cl:- (x zaxis)) (cl:- (y zaxis)) (cl:- (z zaxis)))))

;;----------------------------------------------------------------
