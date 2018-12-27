;;; biblio-bibsonomy.el --- Lookup and import bibliographic entries from Bibsonomy -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Lookup and download bibliographic records from Bibsonomy.  Requires
;; a valid Bibsonomy username API key (set in the
;; `biblio-bibsonomy-username' and `biblio-bibsonomy-api-key'
;; variables).

;;; Code:

(require 'biblio-core)

(defcustom biblio-bibsonomy-username nil
  "Username for Bibsonomy API."
  :group 'biblio-bibsonomy
  :type 'string)

(defcustom biblio-bibsonomy-api-key nil
  "API key for Bibsonomy API."
  :group 'biblio-bibsonomy
  :type 'string)

(defconst biblio-bibsonomy--api-url-root "www.bibsonomy.org/api")

;;;###autoload
(defun biblio-bibsonomy-backend (command &optional arg &rest more)
  "A Bibsonomy backend for biblio.el.
COMMAND, ARG, MORE: See `biblio-backends'."
  (pcase command
    (`name "Bibsonomy")
    (`prompt "Bibsonomy query: ")
    (`url (biblio-bibsonomy--url arg))
    (`parse-buffer (biblio-bibsonomy--parse-search-results))
    (`forward-bibtex (biblio-bibsonomy--forward-bibtex arg (car more)))
    (`register (add-to-list 'biblio-backends #'biblio-dblp-backend))))

(defun biblio-bibsonomy--url (query)
  "Create a Bibsonomy url to look up QUERY."
  (format "https://%s:%s@%s/posts?resourcetype=bibtex&format=bibtex&search=%s"
          biblio-bibsonomy-username biblio-bibsonomy-api-key
          biblio-bibsonomy--api-url-root (url-encode-url query)))

(defun biblio-bibsonomy--intern-keys (alist)
  "Intern keys of ALIST into symbols."
  (mapcar #'(lambda (x) (cons (intern (car x)) (cdr x))) alist))

(defun biblio-bibsonomy--parse-entry ()
  "Parse a single bibtex entry and advance to the next line."
  (let ((start-point (point))
        (bibtex-string)
        (bibtex-expand-strings t)
        (bibtex-autokey-edit-before-use nil)
        (bibtex-entry (bibtex-parse-entry t)))
    (when bibtex-entry
      (bibtex-clean-entry t)
      (setq bibtex-entry (bibtex-parse-entry t))  ; re-parse post clean
      (setq bibtex-string (buffer-substring-no-properties
                           start-point (1+ (point))))
      (forward-line)
      (let-alist (biblio-bibsonomy--intern-keys bibtex-entry)
        (list (cons 'doi .doi)
              (cons 'bibtex bibtex-string)
              (cons 'title (format "%s (%s)" .title .year))
              (cons 'authors (s-split " and " .author))
              (cons 'publisher .publisher)
              (cons 'container .journal)
              (cons 'type .=type=)
              (cons 'url .url)
              (cons 'direct-url .url)))
      )))

(defun biblio-bibsonomy--parse-search-results ()
  "Extract search results from Bibsonomy response."
  (biblio-decode-url-buffer 'utf-8)
  ; TODO: handle HTTP, auth, and other failures
  (loop do (setq entry (biblio-bibsonomy--parse-entry))
        when (not entry)
        return entries
        collect entry into entries))

(defun biblio-bibsonomy--forward-bibtex (metadata forward-to)
  "Forward BibTeX for Bibsonomy entry METADATA to FORWARD-TO."
  (let-alist metadata
    (funcall forward-to .bibtex)))

;;; biblio-bibsonomy.el ends here
