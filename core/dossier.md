# The Session Dossier

A scratch file — `.lens-dossier.md` in the project root — holding what is already
known, so no lens re-asks an answered question.

## Lifecycle

- **Created/reset by /lens:socratic step 1**, with this header:

      # Lens Dossier
      goal: <the stated objective, verbatim>
      date: <YYYY-MM-DD>
      stack: <filled by detection>

- **Validity for standalone lens runs**: a dossier is USABLE only if its `goal`
  plausibly matches the current task AND `date` is within 7 days. If it looks
  reusable but you are not sure, ask the user one yes/no question. Otherwise treat
  it as absent (do not delete it; /lens:socratic owns resets).
- **Git exclusion**: on creation, append `.lens-dossier.md` to `.git/info/exclude`
  (no working-tree diff). If `.git/info/exclude` is not writable or absent, propose
  a `.gitignore` entry to the user — never silently edit `.gitignore`.

## Single-writer rule

Only the main session writes the dossier. Read-only evidence-gathering subagents
(audit mode) receive its content in their prompt and RETURN findings; the lens merges
and writes once.

## Sections

    ## answered      ← question + answer, one bullet each, appended by every lens/round
    ## frontier      ← LIVE mind-map of open question-branches (protocol.md "The frontier"):
                       a TREE — spawned branches nested under the answer that opened them,
                       each node tagged [status][stakes] (open/deepening/answered/deferred/
                       dropped · HIGH/MED/LOW); drained by stakes as branches resolve
    ## decisions     ← decisions made: one-line rationale + ripple note (what it touches —
                       consumers/contracts/styles/deps/platforms; protocol.md "Interrogate
                       decisions"); non-trivial ripples become frontier branches
    ## caveats / rabbit-holes / blast-radius / platform-matrix  ← the four excavations (protocol.md)
    ## open          ← branches consciously DEFERRED at synthesis + who/what resolves them

## Skip lines (mandatory)

When a lens skips a question because the dossier answers it, it MUST print:

    skipping: <question> — answered in <where>

These lines are the visible proof the dossier works. Never skip silently.
