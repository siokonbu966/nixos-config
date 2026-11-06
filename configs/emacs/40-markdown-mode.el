(defvar-local my-markdown-mermaid-preview-file nil)

(defun my-markdown-format-buffer-with-prettier ()
  "Format the whole Markdown buffer with Prettier."
  (interactive)
  (unless (derived-mode-p 'markdown-mode)
    (user-error "Not in markdown-mode"))
  (unless (executable-find "prettier")
    (user-error "Prettier executable not found"))
  (let* ((input-file (or (buffer-file-name)
                         (expand-file-name "untitled.md" default-directory)))
         (output-buffer (generate-new-buffer " *prettier-output*"))
         (error-file (make-temp-file "prettier-errors-")))
    (unwind-protect
        (let ((status (call-process-region
                        (point-min) (point-max) "prettier" nil
                        (list output-buffer error-file) nil
                        "--stdin-filepath" input-file)))
          (if (and (integerp status) (= status 0))
              (unless (string= (buffer-substring-no-properties (point-min) (point-max))
                               (with-current-buffer output-buffer (buffer-string)))
                (replace-buffer-contents output-buffer)
                (message "Formatted Markdown with Prettier"))
            (user-error "Prettier failed (%s): %s"
                        status
                        (with-temp-buffer
                          (insert-file-contents error-file)
                          (buffer-string))))))
      (kill-buffer output-buffer)
      (delete-file error-file)))

(with-eval-after-load 'markdown-mode
  (define-key markdown-mode-map (kbd "C-c C-f")
              #'my-markdown-format-buffer-with-prettier))

(defun my-markdown-mermaid-preview-output-file ()
  "Return the HTML output path for the current Markdown buffer."
  (let* ((source (or (buffer-file-name) (buffer-name)))
         (base (file-name-base source))
         (dir (expand-file-name "markdown-preview" temporary-file-directory)))
    (make-directory dir t)
    (expand-file-name (concat base ".preview.html") dir)))

(defun my-markdown-mermaid-preview-render ()
  "Render the current Markdown buffer to an HTML file with Mermaid support."
  (interactive)
  (unless (derived-mode-p 'markdown-mode)
    (user-error "Not in markdown-mode"))
  (let* ((output-file (my-markdown-mermaid-preview-output-file))
         (markdown-text (buffer-substring-no-properties (point-min) (point-max)))
         (markdown-base64
           (base64-encode-string
             (encode-coding-string markdown-text 'utf-8)
             t))
         (html (format "<!doctype html>
                       <html lang=\"ja\">
                       <head>
                       <meta charset=\"utf-8\">
                       <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
                       <title>%s</title>
                       <style>
                       body {
                       margin: 0;
                       background: #f6f7fb;
                       color: #1f2937;
                       font-family: -apple-system, BlinkMacSystemFont, \"Segoe UI\", sans-serif;
                       }
                       main {
                       max-width: 960px;
                       margin: 0 auto;
                       padding: 40px 24px 64px;
                       background: #ffffff;
                       min-height: 100vh;
                       box-sizing: border-box;
                       }
                       pre {
                       overflow-x: auto;
                       padding: 12px 16px;
                       border-radius: 10px;
                       background: #111827;
                       color: #f9fafb;
                       white-space: pre;
                       overflow-wrap: normal;
                       word-break: normal;
                       tab-size: 2;
                       }
                       code {
                       font-family: \"SFMono-Regular\", Consolas, monospace;
                       }
                       img {
                       max-width: 100%%;
                       }
                       .mermaid {
                       overflow-x: auto;
                       padding: 8px 0;
                       }
                       </style>
                       </head>
                       <body>
                       <main id=\"preview\"></main>
                       <script src=\"https://cdn.jsdelivr.net/npm/marked/marked.min.js\"></script>
                       <script type=\"module\">
                       import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';

                       const sourceBytes = Uint8Array.from(atob('%s'), c => c.charCodeAt(0));
                       const source = new TextDecoder().decode(sourceBytes);
                       const preview = document.getElementById('preview');
                       preview.innerHTML = marked.parse(source, { breaks: true, gfm: true });

                       mermaid.initialize({ startOnLoad: false });

                       const blocks = Array.from(preview.querySelectorAll('pre code.language-mermaid'));
                       for (const block of blocks) {
                       const pre = block.parentElement;
                       const container = document.createElement('div');
                       container.className = 'mermaid';
                       container.textContent = block.textContent;
                       pre.replaceWith(container);
                       }

                       await mermaid.run({ querySelector: '.mermaid' });
                       </script>
                       </body>
                       </html>"
                       (file-name-nondirectory (or (buffer-file-name) (buffer-name)))
                       markdown-base64)))
    (with-temp-file output-file
                    (insert html))
    (setq my-markdown-mermaid-preview-file output-file)
    output-file))

(defun my-markdown-mermaid-preview-open ()
  "Render the current Markdown buffer and open the preview in a browser."
  (interactive)
  (browse-url-of-file (my-markdown-mermaid-preview-render)))

(defun my-markdown-mermaid-preview-refresh ()
  "Refresh the Markdown preview HTML after saving."
  (when (and my-markdown-mermaid-preview-file
             (derived-mode-p 'markdown-mode))
    (my-markdown-mermaid-preview-render)))

(add-hook 'markdown-mode-hook
          (lambda ()
            (define-key markdown-mode-map (kbd "C-c C-p") #'my-markdown-mermaid-preview-open)
            (add-hook 'after-save-hook #'my-markdown-mermaid-preview-refresh nil t)))
