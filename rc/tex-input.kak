declare-option -docstring "Table used to associate LaTeX symbols with Unicode equivalent" \
               -hidden str-list tex_input_translation_table

declare-option -docstring "Whether tex-input is enabled or disabled" -hidden bool tex_input_enabled

define-command -docstring "Setup the input method by adding all default entries in 'tex_input_translation_table'" \
               -params 0.. tex-input-setup %{
  set-option -add global tex_input_translation_table \
               "times:×" "div:÷" "neg:¬" "pm:±" \
               "^1:¹" "^2:²" "^3:³" "^4:⁴" "^5:⁵" "^6:⁶" "^7:⁷" "^8:⁸" "^9:⁹" "^0:⁰" "^-:⁻" "^+:⁺" "^=:⁼" "^(:⁽" "^):⁾" "^i:ⁱ" "^n:ⁿ" \
               "_1:₁" "_2:₂" "_3:₃" "_4:₄" "_5:₅" "_6:₆" "_7:₇" "_8:₈" "_9:₉" "_0:₀" "_(:₍" "_):₎" "_=:₌" "_+:₊" "_-:₋" "_a:ₐ" "_e:ₑ" "_h:ₕ" "_i:ᵢ" "_j:ⱼ" "_k:ₖ" "_l:ₗ" "_m:ₘ" "_n:ₙ" "_o:ₒ" "_p:ₚ" "_r:ᵣ" "_s:ₛ" "_t:ₜ" "_u:ᵤ" "_v:ᵥ" "_x:ₓ" \
               "alpha:ɑ" "Alpha:Α" "beta:β" "Beta:Β" "gamma:γ" "Gamma:Γ" "delta:δ" "Delta:Δ" "epsilon:ε" "Epsilon:Ε" "zeta:ζ" "Zeta:Ζ" "eta:η" "Eta:Η" "theta:θ" "Theta:Θ" "iota:ι" "Iota:Ι" "kappa:κ" "Kappa:Κ" "lambda:λ" "Lambda:Λ" "mu:μ" "Mu:Μ" "nu:ν" "Nu:Ν" "xi:ξ" "Xi:Ξ" "omicron:ο" "Omicron:Ο" "pi:π" "Pi:Π" "rho:ρ" "Rho:Ρ" "sigma:σ" "Sigma:Σ" "tau:τ" "Tau:Τ" "upsilon:υ" "Upsilon:Υ" "phi:φ" "Phi:Φ" "chi:χ" "Chi:Χ" "psi:ψ" "Psi:Ψ" "omega:ω" "Omega:Ω" \
               "forall:∀" "to:→" "->:→" "gets:←" "<-:←" "implies:⇒" "Rightarrow:⇒" "=>:⇒" "Leftarrow:⇐" "<=:⇐" "leftwavearrow:↜" "<~:↜" "rightwavearrow:↝" "~>:↝" "leftrightwavearrow:↭" "<~>:↭" \
               "\\:\\" \
               "prod:∏" "coprod:∐" "sum:∑" \
               "(.):⊙" "(x):⊗" "(+):⊕" "(-):⊖" "(/):⊘" "(*):⊛" "(<):⧀" "(>):⧁" "(=):⊜" \
               "mathbb{N}:ℕ" "bbN:ℕ" \
               "setminus:∖" "cup:∪" "cap:∩" "subset:⊂" "notsubset:⊄" "subseteq:⊆" "notsubseteq:⊈" "in:∈" "notin:∉" \
               "coloneq:≔" "\:=:≔" \
               "land:∧" "/\\:∧" "lor:∨" "\\/:∨" \
               %arg{@}
  # TODO: add more
}

define-command -docstring "Enables the LaTeX input method in the current buffer" \
               -params 0 tex-input-enable %{
  hook -group tex-input buffer InsertChar "\\" %{
    map buffer prompt "<space>" "<ret>"
    
    prompt "tex-input: " -on-abort %{
      try %{ execute-keys "<backspace>" } # remove the `\` inserted
    } -shell-script-candidates %{
      perl -CS -F'(?<!(?<!\\)\\):' -lane 'BEGIN{$/ = " "} @F[0] =~ s/\\:/:/; @F[0] =~ s/\\\\/\\/; print @F[0] . " "' <<< "$kak_opt_tex_input_translation_table"
    } %{
      evaluate-commands %sh{        
        PERL_CODE='BEGIN{$/ = " "} @F[0] =~ s/\\\\/\\/; @F[1] =~ s/\\\\/\\/; @F[0] =~ s/\\:/:/; @F[1] =~ s/\\:/:/; print @F[1] if "@F[0] " eq '
        PERL_CODE="$PERL_CODE'${kak_text%% } '"
        # We need to include a space at the end of the string to prevent expanding `\'` therefore causing a syntax error

        RESULT=$(perl -CS -F'(?<!(?<!\\)\\):' -lane "$PERL_CODE" <<< "$kak_opt_tex_input_translation_table")

        echo "unmap buffer prompt '<space>'"

        echo "set-register dquote '$RESULT '"
        echo "execute-keys \"<backspace><a-;><s-p>\""
        # echo "execute-keys -with-hooks \"i\""
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
