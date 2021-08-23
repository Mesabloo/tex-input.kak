declare-option -docstring "Table used to associate LaTeX symbols with Unicode equivalent" \
               -hidden str-to-str-map tex_input_translation_table

define-command -docstring "Setup the input method by adding all default entries in 'tex_input_translation_table'" \
               -params 0.. tex-input-setup %{
  set-option -add global tex_input_translation_table \
               "times=×" "div=÷" "neg=¬" "pm=±" \
               "^1=¹" "^2=²" "^3=³" "^4=⁴" "^5=⁵" "^6=⁶" "^7=⁷" "^8=⁸" "^9=⁹" "^0=⁰" \
               "lambda=λ" "Lambda=Λ" "alpha=ɑ" \
               %arg{@}
  # TODO: add more
}

define-command -docstring "Enables the LaTeX input method in the current buffer" \
               -params 0 tex-input-enable %{
  hook buffer InsertKey "\\" %{
    prompt "tex-input: " -on-abort %{
      try %{ execute-keys "<backspace>" } # remove the `\` inserted
    } -shell-script-candidates %{
      awk -vRS=' ' -F'=' '{ print $1 }' <<< "$kak_opt_tex_input_translation_table"
    } %{
      evaluate-commands %sh{
        RESULT=$(awk -vRS=' ' -vFIELD="$kak_text" -F'=' '$1 == FIELD { print $2 }' <<< "$kak_opt_tex_input_translation_table")

        echo "set-register dquote \"$RESULT\""
        echo "execute-keys \"<backspace><esc><s-p>\""
        echo "execute-keys -with-hooks \"i\""
      }
    } 
  }
}
