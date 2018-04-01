(in-package #:rtg-math.vector3.non-consing)

;;----------------------------------------------------------------

(defn-inline set-components ((x single-float) (y single-float) (z single-float)
                             (vec vec3)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (setf (x vec) x
        (y vec) y
        (z vec) z)
  vec)

;;----------------------------------------------------------------

(defn +s ((vec3 vec3) (scalar single-float)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (cl:incf (x vec3) scalar)
  (cl:incf (y vec3) scalar)
  (cl:incf (z vec3) scalar)
  vec3)

;;----------------------------------------------------------------

(defn -s ((vec3 vec3) (scalar single-float)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (cl:decf (x vec3) scalar)
  (cl:decf (y vec3) scalar)
  (cl:decf (z vec3) scalar)
  vec3)

;;---------------------------------------------------------------

(defn %+ ((accum-vec vec3) (to-add-vec vec3)) vec3
  (declare (vec3 accum-vec to-add-vec))
  (cl:incf (aref accum-vec 0) (aref to-add-vec 0))
  (cl:incf (aref accum-vec 1) (aref to-add-vec 1))
  (cl:incf (aref accum-vec 2) (aref to-add-vec 2))
  accum-vec)

(defn + ((accum-vec vec3) &rest (vec3s vec3)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (loop :for vec :in vec3s :do (%+ accum-vec vec))
  accum-vec)

(define-compiler-macro + (&whole whole accum-vec &rest vec3s)
  (assert accum-vec)
  (case= (cl:length vec3s)
    (0 accum-vec)
    (1 `(%+ ,accum-vec ,(first vec3s)))
    (otherwise whole)))

;;---------------------------------------------------------------

(defn %- ((accum-vec vec3) (to-add-vec vec3)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (cl:decf (aref accum-vec 0) (aref to-add-vec 0))
  (cl:decf (aref accum-vec 1) (aref to-add-vec 1))
  (cl:decf (aref accum-vec 2) (aref to-add-vec 2))
  accum-vec)

(defn - ((accum-vec vec3) &rest (vec3s vec3)) vec3
  (loop :for vec :in vec3s :do (%- accum-vec vec))
  accum-vec)

(define-compiler-macro - (&whole whole accum-vec &rest vec3s)
  (assert accum-vec)
  (case= (cl:length vec3s)
    (0 accum-vec)
    (1 `(%- ,accum-vec ,(first vec3s)))
    (otherwise whole)))

;;---------------------------------------------------------------

(defn %* ((accum-vec vec3) (to-mult-vec vec3)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (cl:setf (aref accum-vec 0) (cl:* (aref accum-vec 0) (aref to-mult-vec 0)))
  (cl:setf (aref accum-vec 1) (cl:* (aref accum-vec 1) (aref to-mult-vec 1)))
  (cl:setf (aref accum-vec 2) (cl:* (aref accum-vec 2) (aref to-mult-vec 2)))
  accum-vec)

(defn * ((accum-vec vec3) &rest (vec3s vec3)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (loop :for vec :in vec3s :do (%* accum-vec vec))
  accum-vec)

(define-compiler-macro * (&whole whole accum-vec &rest vec3s)
  (assert accum-vec)
  (case= (cl:length vec3s)
    (0 accum-vec)
    (1 `(%* ,accum-vec ,(first vec3s)))
    (otherwise whole)))

;;---------------------------------------------------------------

(defn *s ((vec3 vec3) (a single-float)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (setf (x vec3) (cl:* (x vec3) a))
  (setf (y vec3) (cl:* (y vec3) a))
  (setf (z vec3) (cl:* (z vec3) a))
  vec3)

;;---------------------------------------------------------------

(defn /s ((vec3 vec3) (a single-float)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (setf (x vec3) (cl:/ (x vec3) a))
  (setf (y vec3) (cl:/ (y vec3) a))
  (setf (z vec3) (cl:/ (z vec3) a))
  vec3)

;;---------------------------------------------------------------

(defn / ((vec3-a vec3) (vec3-b vec3)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (setf (x vec3-a) (cl:/ (x vec3-a) (x vec3-b)))
  (setf (y vec3-a) (cl:/ (y vec3-a) (y vec3-b)))
  (setf (z vec3-a) (cl:/ (z vec3-a) (z vec3-b)))
  vec3-a)

;;---------------------------------------------------------------

(defn negate ((vector-a vec3)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (set-components (cl:- (x vector-a))
                  (cl:- (y vector-a))
                  (cl:- (z vector-a))
                  vector-a))

;;---------------------------------------------------------------

(defn rotate ((vec vec3) (rotation vec3)) vec3
  ;; this was based on rotation-from-euler, so this rotates clockwise
  ;; which is ass
  (let* ((x (x vec))
         (y (y vec))
         (z (z vec))
         (rx (x rotation))
         (ry (y rotation))
         (rz (z rotation))
         (sx (sin rx)) (cx (cos rx))
         (sy (sin ry)) (cy (cos ry))
         (sz (sin rz)) (cz (cos rz)))
    (v3-n:set-components (cl:+ (cl:* x (cl:* cy cz))
                               (cl:* y (cl:- (cl:* cy sz)))
                               (cl:* z sy))
                         (cl:+ (cl:* x (cl:+ (cl:* sx sy cz) (cl:* cx sz)))
                               (cl:* y (cl:- (cl:* cx cz) (cl:* sx sy sz)))
                               (cl:* z (cl:- (cl:* sx cy))))
                         (cl:+ (cl:* x (cl:- (cl:* sx sz) (cl:* cx sy cz)))
                               (cl:* y (cl:+ (cl:* cx sy sz) (cl:* sx cz)))
                               (cl:* z (cl:* cx cy)))
                         vec)))

;;---------------------------------------------------------------

(defn normalize ((vector-a vec3)) vec3
  (declare (optimize (speed 3) (safety 1) (debug 1)))
  (let* ((x (x vector-a))
         (y (y vector-a))
         (z (z vector-a))
         (len-sqr (cl:+ (cl:* x x) (cl:* y y) (cl:* z z))))
    (if (cl:= 0f0 len-sqr)
        vector-a
        (*s vector-a (inv-sqrt len-sqr)))))

;;---------------------------------------------------------------
