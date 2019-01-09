;;; flycheck-vera.el --- A flycheck checker for vera++

;; Copyright © 2019 Jacob Salzberg

;; Author: Jacob Salzberg <jssalzbe>
;; URL: https://github.com/jsalzbergedu/flycheck-vera
;; Version: 0.1.0
;; Keywords: flycheck vera syntax checker

;; This file is not a part of GNU Emacs

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; This package defines a flycheck checker using vera++:
;; https://github.com/verateam/vera/tree/cf13c413f641b5816a4fc9cd4b2fb248c81bf2bd
;; To use this syntax checker, first install vera.  On archlinux that is best
;; done through the AUR using the package:
;; https://aur.archlinux.org/vera++.git
;; and on ubuntu through the normal package archives with
;; sudo apt-get install vera++
;; after enabling the universe repositories.
;; Furthermore, you must ensure that you have flycheck installed.
;; Once you have vera++ and flycheck installed, use this package by
;; putting this package in your load path and adding
;; (require 'flycheck-vera)
;; or
;; (use-package flycheck-vera
;;   ;; configuration goes here
;;  )
;; to your config.
;; Finally, configure this package via the variables
;; flycheck-vera-rules and flycheck-vera-parameters.
;; This package has been patterned off of
;; https://github.com/flycheck/flycheck-google-cpplint/blob/master/flycheck-google-cpplint.el

;;; Code:
(when (not (featurep 'flycheck))
  (require 'flycheck))

(flycheck-def-option-var flycheck-vera-rules nil c/c++-vera++
  "Which rules to run.
Nil runs all the rules in the default profile.
Example: `(setq flycheck-vera-rules (list \"L001\"))'"
  :type '(list :tag "Which rules to run.")
  :safe #'listp
  :package-version '(flycheck . "32"))

(flycheck-def-option-var flycheck-vera-parameters nil c/c++-vera++
  "Which parameters to add.
Nil means all parameters are at their default values.
Parameters should be alists of the format (cons name value).
Example: `(setq flycheck-vera-parameters (list (cons \"max-line-length\" \"80\")))'"
  :type '(list :tag "An alist of which parameters to set, and what they are set to.")
  :safe #'listp
  :package-version '(flycheck . "32"))

(defun flycheck-vera-prepend (option item)
  "Prepend the OPTION to the ITEM value."
  (format "%s%s=%s" option (car item) (cdr item)))

;;;###autoload
(flycheck-define-checker c/c++-vera++
  "A flycheck checker for C/C++ files using vera++."
  :command ("vera++"
            (option-list "-R " flycheck-vera-rules concat)
            (option-list "-P " flycheck-vera-parameters flycheck-vera-prepend)
            source-original)
  :error-patterns
  ((warning line-start (file-name) ":" line ":" (message) line-end))
  :modes (c-mode c++-mode))

;;;###autoload
(add-to-list 'flycheck-checkers 'c/c++-vera++ 'append)

(provide 'flycheck-vera)
;;; flycheck-vera.el ends here
