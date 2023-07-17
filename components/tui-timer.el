;;; tui-timer.el --- A basic timer       -*- lexical-binding: t; -*-

;;; Commentary:
;; 

;;; Code:

(require 'tui-defun)
(require 'tui-util)

(tui-define-component tui-timer
  :component-did-mount
  (lambda (component)
    (cl-labels ((tick ()
                      (tui-run-with-timer component
                                          1
                                          nil
                                          nil
                                          (lambda ()
                                            (let ((next-state (copy-sequence (tui-get-state component))))
                                              (plist-put next-state 'current-time-seconds (truncate (time-to-seconds)))
                                              (tui-set-state component next-state))
                                            (tick)))))
      (tick)))
  :get-initial-state
  (lambda (_)
    (let ((start-time (current-time)))
      (list 'start-time start-time
            'current-time-seconds (truncate (time-to-seconds start-time)))))
  :render
  (lambda (component)
    (let* ((state (tui-get-state component))
           (start-time-seconds (truncate (time-to-seconds (plist-get state 'start-time))))
           (current-time-seconds (plist-get state 'current-time-seconds))
           (elapsed-seconds (- current-time-seconds start-time-seconds))
           (days (truncate (/ elapsed-seconds 86400)))
           (hours (truncate (/ (% elapsed-seconds 86400) 3600)))
           (minutes (truncate (/ (% elapsed-seconds 3600) 60)))
           (seconds (truncate (% elapsed-seconds 60))))
      (tui-span
       (when (> days 0)
         (format "%d days " days))
       (when (> hours 0)
         (format "%02d" hours))
       (format "%02d:%02d" minutes seconds)))))

(provide 'tui-timer)
;;; tui-demo-timer.el ends here
