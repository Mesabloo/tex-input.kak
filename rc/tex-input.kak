declare-option -docstring "Table used to associate LaTeX symbols with Unicode equivalent" \
               -hidden str-list tex_input_translation_table

declare-option -docstring "Whether tex-input is enabled or disabled" -hidden bool tex_input_enabled

define-command -docstring "Setup the input method by adding all default entries in 'tex_input_translation_table'" \
               -params 0.. tex-input-setup %{
  set-option -add global tex_input_translation_table \
               "times:×" "div:÷" "neg:¬" "pm:±" \
               "^1:¹" "^2:²" "^3:³" "^4:⁴" "^5:⁵" "^6:⁶" "^7:⁷" "^8:⁸" "^9:⁹" "^0:⁰" "^-:⁻" "^+:⁺" "^=:⁼" "^(:⁽" "^):⁾" "^i:ⁱ" "^n:ⁿ" \
               "_1:₁" "_2:₂" "_3:₃" "_4:₄" "_5:₅" "_6:₆" "_7:₇" "_8:₈" "_9:₉" "_0:₀" "_(:₍" "_):₎" "_=:₌" "_+:₊" "_-:₋" "_a:ₐ" "_e:ₑ" "_h:ₕ" "_i:ᵢ" "_j:ⱼ" "_k:ₖ" "_l:ₗ" "_m:ₘ" "_n:ₙ" "_o:ₒ" "_p:ₚ" "_r:ᵣ" "_s:ₛ" "_t:ₜ" "_u:ᵤ" "_v:ᵥ" "_x:ₓ" \
               "lambda:λ" "Lambda:Λ" "alpha:ɑ" \
               "\\:\\" \
               "mathbb{N}:ℕ" \
               %arg{@}
  # TODO: add more
}

define-command -docstring "Enables the LaTeX input method in the current buffer" \
               -params 0 tex-input-enable %{
  hook -group tex-input buffer InsertChar "\\" %{
    prompt "tex-input: " -on-abort %{
      try %{ execute-keys "<backspace>" } # remove the `\` inserted
    } -shell-script-candidates %{
      awk -vRS=' ' -F':' '{ print $1 }' <<< "$kak_opt_tex_input_translation_table"
    } %{
      evaluate-commands %sh{
        INPUT="$kak_text"
        if [ "$INPUT" = '\' ]; then
          INPUT='\\'
        fi
        
        RESULT=$(awk -vRS=' ' -vFIELD="$INPUT" -F':' '$1 == FIELD { print $2 }' <<< "$kak_opt_tex_input_translation_table")

        echo "set-register dquote '$RESULT'"
        echo "execute-keys \"<backspace><esc><s-p>\""
        echo "execute-keys -with-hooks \"i\""
      }
    } 
  }

  set-option global tex_input_enabled true
}

define-command -docstring "Disables the LaTeX input method in the current buffer" \
               -params 0 tex-input-disable %{
  remove-hooks buffer tex-input

  set-option global tex_input_enabled false
}

define-command -docstring "Toggles the LaTeX input method in the current buffer" \
               -params 0 tex-input-toggle %{
  evaluate-commands %sh{
    if [ "$kak_opt_tex_input_enabled" = "true" ]; then
      echo "tex-input-disable"
    else
      echo "tex-input-enable"
    fi
  }               
}
