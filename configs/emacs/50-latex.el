;;; 50-latex.el --- LaTeX configuration -*- lexical-binding: t; -*-

;; AUCTeX
(require 'tex)
(require 'latex)

;; LuaLaTeX + latexmk
(add-to-list
 'TeX-command-list
 '("Latexmk"
   "latexmk -lualatex -synctex=1 -interaction=nonstopmode -file-line-error %s"
   TeX-run-TeX nil t
   :help "Run latexmk with LuaLaTeX"))

;; デフォルトのコンパイルコマンド
(setq TeX-command-default "Latexmk")

;; PDF出力を有効化
(setq TeX-PDF-mode t)

;; 保存時に自動パース
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;; エラー位置へのジャンプ
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-method 'synctex)

;; PDF Viewer
(cond
 ((eq system-type 'darwin)
  (setq TeX-view-program-selection
        '((output-pdf "Default"))))

 ((eq system-type 'gnu/linux)
  (setq TeX-view-program-selection
        '((output-pdf "Zathura")))
  (setq TeX-view-program-list
        '(("Zathura" "zathura %o")))))

(provide '50-latex)
;;; 50-latex.el ends here
